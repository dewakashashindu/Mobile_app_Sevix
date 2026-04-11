import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  final dynamic theme;
  final String language;
  final VoidCallback onBack;

  const ChatScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.onBack,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot>? _chatsStream;
  String? _selectedChatId;
  String? _selectedWorkerId;
  String? _selectedWorkerName;
  String? _selectedJobTitle;
  String? _selectedWorkerAvatarUrl;
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _chatsStream = FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: currentUser.uid)
          .orderBy('lastMessageTime', descending: true)
          .snapshots();
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final messageTime = timestamp.toDate();
    final difference = now.difference(messageTime);

    if (difference.inSeconds < 60) {
      return _txt('now', 'ඒ දැන්', 'இப்போது');
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 30) {
      return '${difference.inDays ~/ 7}w';
    } else {
      return '${messageTime.day}/${messageTime.month}';
    }
  }

  String _truncateMessage(String message, int maxLength) {
    if (message.length <= maxLength) return message;
    return '${message.substring(0, maxLength)}...';
  }

  Widget _buildChatTile(DocumentSnapshot chatDoc) {
    final chatData = chatDoc.data() as Map<String, dynamic>;
    final lastMessage = chatData['lastMessage'] ?? '';
    final lastMessageTime = chatData['lastMessageTime'] as Timestamp?;
    final participants = List<String>.from(chatData['participants'] ?? []);

    final currentUser = FirebaseAuth.instance.currentUser;
    final workerId = participants.firstWhere(
      (id) => id != currentUser?.uid,
      orElse: () => '',
    );

    final unreadCountKey = 'unreadCount_${currentUser?.uid}';
    final unreadCount = chatData[unreadCountKey] ?? 0;

    final workerName =
        chatData['workerName'] ?? _txt('Worker', 'සේවකයා', 'பணியாளர்');
    final jobTitle = chatData['jobTitle'] ?? '';
    final workerAvatarUrl = chatData['workerAvatarUrl'] as String?;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: widget.theme.primary,
        backgroundImage: workerAvatarUrl != null
            ? NetworkImage(workerAvatarUrl)
            : null,
        child: workerAvatarUrl == null
            ? Text(
                workerName.isNotEmpty ? workerName[0].toUpperCase() : 'W',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        workerName,
        style: TextStyle(
          color: widget.theme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (jobTitle.isNotEmpty)
            Text(
              jobTitle,
              style: TextStyle(color: widget.theme.textSecondary, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          Text(
            _truncateMessage(lastMessage, 40),
            style: TextStyle(color: widget.theme.textSecondary, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(lastMessageTime),
            style: TextStyle(color: widget.theme.textSecondary, fontSize: 12),
          ),
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  unreadCount > 99 ? '99+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        setState(() {
          _selectedChatId = chatDoc.id;
          _selectedWorkerId = workerId;
          _selectedWorkerName = workerName;
          _selectedJobTitle = jobTitle;
          _selectedWorkerAvatarUrl = workerAvatarUrl;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedChatId != null) {
      return ChatDetailScreen(
        theme: widget.theme,
        language: widget.language,
        chatId: _selectedChatId!,
        workerId: _selectedWorkerId ?? '',
        workerName: _selectedWorkerName ?? _txt('Worker', 'සේවකයා', 'பணியாளர்'),
        jobTitle: _selectedJobTitle ?? '',
        workerAvatarUrl: _selectedWorkerAvatarUrl,
        onBack: () => setState(() {
          _selectedChatId = null;
          _selectedWorkerId = null;
          _selectedWorkerName = null;
          _selectedJobTitle = null;
          _selectedWorkerAvatarUrl = null;
        }),
      );
    }

    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: widget.theme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1533),
        foregroundColor: Colors.white,
        title: Text(_txt('Messages', 'පණිවිඩ', 'செய்திகள்')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: _txt(
                  'Search by name or job...',
                  'නම හෝ වැඩ් අනුසරණය කරන්න...',
                  'பெயர் அல்லது வேலையால் தேடவும்...',
                ),
                hintStyle: TextStyle(color: widget.theme.inputPlaceholder),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: widget.theme.inputBackground,
              ),
            ),
          ),
          Expanded(
            child: currentUser == null || _chatsStream == null
                ? Center(
                    child: Text(
                      _txt(
                        'Please sign in to view messages.',
                        'පණිවිඩ බැලීමට කරුණාකර පිවිසෙන්න.',
                        'செய்திகளை பார்க்க உள்நுழையவும்.',
                      ),
                      style: TextStyle(color: widget.theme.textSecondary),
                    ),
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: _chatsStream,
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

                      final q = _searchQuery.toLowerCase();
                      final docs = snapshot.data!.docs.where((doc) {
                        if (q.isEmpty) {
                          return true;
                        }
                        final data = doc.data() as Map<String, dynamic>;
                        final workerName = (data['workerName'] ?? '')
                            .toLowerCase();
                        final jobTitle = (data['jobTitle'] ?? '').toLowerCase();
                        return workerName.contains(q) || jobTitle.contains(q);
                      }).toList();

                      if (docs.isEmpty) {
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
                                  'Accept a bid to start chatting',
                                  'සංවාද කිරීම ඉවත් කරන්න',
                                  'சாட் செய்ய ஒரு ஏலத்தை ஏற்கவும்',
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
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          return _buildChatTile(docs[index]);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
