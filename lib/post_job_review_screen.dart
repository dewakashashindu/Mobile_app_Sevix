import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart' show AppTheme;

class JobReviewSubmission {
  final String reviewId;
  final String bookingId;
  final String workerId;
  final double overallRating;
  final Map<String, double> ratings;
  final String comment;
  final List<String> photoUrls;
  final DateTime createdAt;

  const JobReviewSubmission({
    required this.reviewId,
    required this.bookingId,
    required this.workerId,
    required this.overallRating,
    required this.ratings,
    required this.comment,
    required this.photoUrls,
    required this.createdAt,
  });
}

class PostJobReviewScreen extends StatefulWidget {
  final AppTheme theme;
  final String language;
  final String bookingId;
  final String workerId;
  final String workerName;
  final String jobTitle;
  final JobReviewSubmission? existingReview;

  const PostJobReviewScreen({
    super.key,
    required this.theme,
    required this.language,
    required this.bookingId,
    required this.workerId,
    required this.workerName,
    required this.jobTitle,
    this.existingReview,
  });

  @override
  State<PostJobReviewScreen> createState() => _PostJobReviewScreenState();
}

class _PostJobReviewScreenState extends State<PostJobReviewScreen> {
  static const _dimensions = <String>[
    'quality',
    'timeliness',
    'communication',
    'professionalism',
    'value',
  ];

  final _commentCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late final Map<String, double> _ratings;
  final List<XFile> _photos = [];
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _ratings = {
      'quality': widget.existingReview?.ratings['quality'] ?? 5,
      'timeliness': widget.existingReview?.ratings['timeliness'] ?? 5,
      'communication': widget.existingReview?.ratings['communication'] ?? 5,
      'professionalism': widget.existingReview?.ratings['professionalism'] ?? 5,
      'value': widget.existingReview?.ratings['value'] ?? 5,
    };
    _commentCtrl.text = widget.existingReview?.comment ?? '';
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
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

  String _label(String key) {
    switch (key) {
      case 'quality':
        return _txt('Work Quality', 'වැඩ ගුණාත්මකභාවය', 'வேலையின் தரம்');
      case 'timeliness':
        return _txt('Timeliness', 'කාල නිරවද්‍යතාව', 'நேரத்திற்கு வந்தது');
      case 'communication':
        return _txt('Communication', 'සන්නිවේදනය', 'தொடர்பு திறன்');
      case 'professionalism':
        return _txt('Professionalism', 'වෘත්තීයභාවය', 'தொழில்முறை நடத்தை');
      case 'value':
        return _txt('Value for Money', 'මුදලට වටිනාකම', 'பணத்திற்கு மதிப்பு');
      default:
        return key;
    }
  }

  double get _overallRating {
    final total = _dimensions.fold<double>(
      0,
      (runningTotal, key) => runningTotal + (_ratings[key] ?? 0),
    );
    return total / _dimensions.length;
  }

  Future<void> _pickPhotos() async {
    try {
      final picked = await _picker.pickMultiImage(
        imageQuality: 75,
        maxWidth: 1800,
      );
      if (!mounted) return;
      setState(() {
        _photos
          ..clear()
          ..addAll(picked.take(5));
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _txt(
              'Could not open photo gallery',
              'ඡායාරූප එකතුව විවෘත කළ නොහැක',
              'புகைப்படத் தொகுப்பை திறக்க முடியவில்லை',
            ),
          ),
        ),
      );
    }
  }

  Future<List<String>> _uploadPhotos(String reviewId) async {
    if (_photos.isEmpty) return const [];

    final urls = <String>[];
    for (var i = 0; i < _photos.length; i++) {
      final photo = _photos[i];
      final Uint8List bytes = await photo.readAsBytes();
      final ref = FirebaseStorage.instance.ref().child(
        'reviews/${widget.bookingId}/$reviewId-$i.jpg',
      );

      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await ref.putData(bytes, metadata);
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  Future<void> _submitReview() async {
    if (_submitting) return;

    setState(() => _submitting = true);

    try {
      final reviewId =
          widget.existingReview?.reviewId ??
          '${widget.bookingId}_${DateTime.now().millisecondsSinceEpoch}';
      final uploadedPhotoUrls = await _uploadPhotos(reviewId);
      final photoUrls = uploadedPhotoUrls.isNotEmpty
          ? uploadedPhotoUrls
          : (widget.existingReview?.photoUrls ?? const <String>[]);

      final payload = <String, dynamic>{
        'reviewId': reviewId,
        'bookingId': widget.bookingId,
        'workerId': widget.workerId,
        'workerName': widget.workerName,
        'jobTitle': widget.jobTitle,
        'ratings': _ratings,
        'overallRating': _overallRating,
        'comment': _commentCtrl.text.trim(),
        'photoUrls': photoUrls,
        'photoCount': photoUrls.length,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.existingReview == null) {
        payload['createdAt'] = FieldValue.serverTimestamp();
      }

      await FirebaseFirestore.instance
          .collection('job_reviews')
          .doc(reviewId)
          .set(payload, SetOptions(merge: true));

      if (!mounted) return;

      Navigator.of(context).pop(
        JobReviewSubmission(
          reviewId: reviewId,
          bookingId: widget.bookingId,
          workerId: widget.workerId,
          overallRating: _overallRating,
          ratings: Map<String, double>.from(_ratings),
          comment: _commentCtrl.text.trim(),
          photoUrls: photoUrls,
          createdAt: DateTime.now(),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _txt(
              'Failed to submit review. Please try again.',
              'සමාලෝචනය යැවීමට අසාර්ථකයි. නැවත උත්සාහ කරන්න.',
              'மதிப்புரையை சமர்ப்பிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1533),
        foregroundColor: Colors.white,
        title: Text(
          _txt('Rate Your Worker', 'සේවකයා ඇගයීම', 'பணியாளரை மதிப்பிடுக'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.jobTitle,
            style: TextStyle(
              color: widget.theme.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.workerName,
            style: TextStyle(color: widget.theme.textSecondary),
          ),
          const SizedBox(height: 16),
          Card(
            color: widget.theme.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: widget.theme.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _txt(
                      'Rate each area (1-5)',
                      'සෑම අංශයක්ම 1-5 ලෙස අගයන්න',
                      'ஒவ்வொரு பகுதியையும் 1-5 ஆக மதிப்பிடவும்',
                    ),
                    style: TextStyle(
                      color: widget.theme.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._dimensions.map((key) {
                    final value = _ratings[key] ?? 5;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _label(key),
                                  style: TextStyle(
                                    color: widget.theme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                value.toStringAsFixed(1),
                                style: TextStyle(
                                  color: widget.theme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: value,
                            min: 1,
                            max: 5,
                            divisions: 8,
                            onChanged: (newValue) {
                              setState(() {
                                _ratings[key] = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber.shade700),
                      const SizedBox(width: 6),
                      Text(
                        _txt(
                          'Overall: ${_overallRating.toStringAsFixed(1)} / 5.0',
                          'සමස්තය: ${_overallRating.toStringAsFixed(1)} / 5.0',
                          'மொத்தம்: ${_overallRating.toStringAsFixed(1)} / 5.0',
                        ),
                        style: TextStyle(
                          color: widget.theme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentCtrl,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: _txt(
                'Write your feedback (optional)',
                'ඔබගේ අදහස ලියන්න (විකල්ප)',
                'உங்கள் கருத்தை எழுதவும் (விருப்பம்)',
              ),
              filled: true,
              fillColor: widget.theme.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: widget.theme.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: widget.theme.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _txt(
                      'Upload photos (up to 5)',
                      'ඡායාරූප උඩුගත කරන්න (5 දක්වා)',
                      'புகைப்படங்களைப் பதிவேற்றுக (அதிகபட்சம் 5)',
                    ),
                    style: TextStyle(
                      color: widget.theme.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final photo in _photos)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: FutureBuilder<Uint8List>(
                            future: photo.readAsBytes(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                  width: 72,
                                  height: 72,
                                  color: widget.theme.inputBackground,
                                );
                              }
                              return Image.memory(
                                snapshot.data!,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: _pickPhotos,
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: Text(
                      _txt(
                        'Select Photos',
                        'ඡායාරූප තෝරන්න',
                        'புகைப்படங்கள் தேர்வு',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _submitting ? null : _submitReview,
            icon: _submitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Text(
              _submitting
                  ? _txt(
                      'Submitting...',
                      'යවමින්...',
                      'சமர்ப்பிக்கப்படுகிறது...',
                    )
                  : _txt(
                      'Submit Review',
                      'සමාලෝචනය යවන්න',
                      'மதிப்புரையை சமர்ப்பிக்கவும்',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
