import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatDetailScreen extends StatefulWidget {
  final dynamic theme;
  final String language;
  final String chatId;
  final String workerId;
  final String workerName;
  final String jobTitle;
  final String? workerAvatarUrl;
  final VoidCallback onBack;

  const ChatDetailScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.chatId,
    required this.workerId,
    required this.workerName,
    required this.jobTitle,
    this.workerAvatarUrl,
    required this.onBack,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late Stream<QuerySnapshot> _messagesStream;
  final _imagePicker = ImagePicker();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _messagesStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    _markChatAsRead();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _markChatAsRead() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final chatRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId);

      await chatRef.update({'unreadCount_${currentUser.uid}': 0});

      final messagesToUpdate = await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .where('senderId', isEqualTo: widget.workerId)
          .where('read', isEqualTo: false)
          .get();

      for (var doc in messagesToUpdate.docs) {
        await doc.reference.update({'read': true});
      }
    } catch (e) {
      // Silently fail
    }
  }

  String _txt(String en, String si, String ta) {
    switch (widget.language) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      default:
        return en;
    }
  }

  String _formatMessageTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final messageTime = timestamp.toDate();
    return '${messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatMessageDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final messageTime = timestamp.toDate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 1));
    final messageDate = DateTime(
      messageTime.year,
      messageTime.month,
      messageTime.day,
    );

    if (messageDate == today) {
      return _txt('Today', 'අද', 'இன்று');
    } else if (messageDate == yesterday) {
      return _txt('Yesterday', 'ඊdated', 'நேற்று');
    } else {
      return '${messageTime.day}/${messageTime.month}/${messageTime.year}';
    }
  }

  Future<void> _sendMessage(String text, [File? imageFile]) async {
    if (text.trim().isEmpty && imageFile == null) return;

    if (_sending) return;

    setState(() => _sending = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final now = FieldValue.serverTimestamp();
      String? imageUrl;

      if (imageFile != null) {
        final uuid = const Uuid().v4();
        final ref = FirebaseStorage.instance.ref().child(
          'chats/${widget.chatId}/images/$uuid.jpg',
        );

        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
            'senderId': currentUser.uid,
            'senderName': currentUser.displayName ?? 'User',
            'text': text.trim(),
            'timestamp': now,
            'read': false,
            'type': imageFile != null ? 'image' : 'text',
            'imageUrl': imageUrl,
          });

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({
            'lastMessage': imageFile != null ? '📸 Image' : text.trim(),
            'lastMessageTime': now,
            'unreadCount_${widget.workerId}': FieldValue.increment(1),
          });

      _messageController.clear();

      if (mounted) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error sending message: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  Future<void> _pickAndSendImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        await _sendMessage('', File(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: widget.theme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1533),
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: widget.theme.primary,
                  backgroundImage: widget.workerAvatarUrl != null
                      ? NetworkImage(widget.workerAvatarUrl!)
                      : null,
                  child: widget.workerAvatarUrl == null
                      ? Text(
                          widget.workerName.isNotEmpty
                              ? widget.workerName[0].toUpperCase()
                              : 'W',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.workerName),
                      if (widget.jobTitle.isNotEmpty)
                        Text(
                          widget.jobTitle,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.theme.primary,
                      ),
                    ),
                  );
                }

                final messages = snapshot.data!.docs.reversed.toList();

                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: widget.theme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _txt(
                            'No messages yet',
                            'තවම පණිවිඩ නොමැත',
                            'இதுவரை செய்திகள் இல்லை',
                          ),
                          style: TextStyle(
                            color: widget.theme.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _txt(
                            'Start the conversation by sending a message',
                            'පණිවිඩ එක් කිරීමෙන් සංවාදය ඪරණ කරන්න',
                            'செய்தி அனுப்பி உரையாடலைத் தொடங்கவும்',
                          ),
                          style: TextStyle(
                            color: widget.theme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageDoc = messages[index];
                    final messageData =
                        messageDoc.data() as Map<String, dynamic>;
                    final senderId = messageData['senderId'] as String?;
                    final text = messageData['text'] as String? ?? '';
                    final imageUrl = messageData['imageUrl'] as String?;
                    final timestamp = messageData['timestamp'] as Timestamp?;
                    final type = messageData['type'] as String? ?? 'text';
                    final isCurrentUser = senderId == currentUser?.uid;

                    String? dateHeader;
                    if (index == 0) {
                      dateHeader = _formatMessageDate(timestamp);
                    } else {
                      final prevMessageTime =
                          (messages[index - 1].data()
                                  as Map<String, dynamic>)['timestamp']
                              as Timestamp?;
                      if (prevMessageTime != null && timestamp != null) {
                        final diff = prevMessageTime.toDate().difference(
                          timestamp.toDate(),
                        );
                        if (diff.inMinutes > 30) {
                          dateHeader = _formatMessageDate(timestamp);
                        }
                      }
                    }

                    return Column(
                      children: [
                        if (dateHeader != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              dateHeader,
                              style: TextStyle(
                                color: widget.theme.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: isCurrentUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isCurrentUser)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: widget.theme.primary,
                                  backgroundImage:
                                      widget.workerAvatarUrl != null
                                      ? NetworkImage(widget.workerAvatarUrl!)
                                      : null,
                                  child: widget.workerAvatarUrl == null
                                      ? Text(
                                          widget.workerName.isNotEmpty
                                              ? widget.workerName[0]
                                                    .toUpperCase()
                                              : 'W',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(
                                  isCurrentUser ? 8 : 4,
                                  4,
                                  isCurrentUser ? 8 : 4,
                                  4,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isCurrentUser
                                      ? widget.theme.primary
                                      : widget.theme.cardBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  border: !isCurrentUser
                                      ? Border.all(
                                          color: widget.theme.border,
                                          width: 1,
                                        )
                                      : null,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (type == 'image' && imageUrl != null)
                                      Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 200,
                                        ),
                                        margin: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (context, child, progress) {
                                                  if (progress == null)
                                                    return child;
                                                  return Container(
                                                    color: Colors.grey[300],
                                                    height: 200,
                                                    width: 200,
                                                    child: const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  );
                                                },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[300],
                                                    height: 200,
                                                    width: 200,
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                    if (text.isNotEmpty)
                                      Text(
                                        text,
                                        style: TextStyle(
                                          color: isCurrentUser
                                              ? Colors.white
                                              : widget.theme.textPrimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatMessageTime(timestamp),
                                      style: TextStyle(
                                        color: isCurrentUser
                                            ? Colors.white.withAlpha(179)
                                            : widget.theme.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 12,
              right: 12,
              top: 12,
            ),
            color: widget.theme.cardBackground,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _sending ? null : _pickAndSendImage,
                  tooltip: _txt(
                    'Send image',
                    'රූපය යවන්න',
                    'படத்தை அனுப்பவும்',
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: !_sending,
                    decoration: InputDecoration(
                      hintText: _txt(
                        'Type a message…',
                        'පණිවිඩයක් ටයිප් කරන්න…',
                        'செய்தியை தட்டச்சு செய்யவும்…',
                      ),
                      hintStyle: TextStyle(
                        color: widget.theme.inputPlaceholder,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: widget.theme.inputBackground,
                    ),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  icon: _sending
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.theme.primary,
                            ),
                          ),
                        )
                      : const Icon(Icons.send),
                  onPressed: _sending
                      ? null
                      : () => _sendMessage(_messageController.text.trim()),
                  tooltip: _txt('Send', 'යවන්න', 'அனுப்பவும்'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
