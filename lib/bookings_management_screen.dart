import 'package:flutter/material.dart';
import 'main.dart' show AppTheme;

class BookingsManagementScreen extends StatefulWidget {
  final AppTheme theme;
  final String selectedLanguage;
  final VoidCallback? onBack;

  const BookingsManagementScreen({
    super.key,
    required this.theme,
    required this.selectedLanguage,
    this.onBack,
  });

  @override
  State<BookingsManagementScreen> createState() =>
      _BookingsManagementScreenState();
}

class _BookingsManagementScreenState extends State<BookingsManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getTranslation(String key) {
    final translations = {
      'bids': {'en': 'Bids', 'si': 'ලංසු', 'ta': 'ஏலங்கள்'},
      'accepted': {
        'en': 'Accepted',
        'si': 'පිළිගත්',
        'ta': 'ஏற்றுக்கொள்ளப்பட்டது',
      },
      'history': {'en': 'History', 'si': 'ඉතිහාසය', 'ta': 'வரலாறு'},
      'noBids': {
        'en': 'No active bids yet',
        'si': 'තවමත් ක්‍රියාකාරී ලංසු නැත',
        'ta': 'இன்னும் செயலில் உள்ள ஏலங்கள் இல்லை',
      },
      'noBidsDesc': {
        'en': 'Post a job request to start receiving bids from workers',
        'si': 'සේවකයන්ගෙන් ලංසු ලැබීම ආරම්භ කිරීමට රැකියා ඉල්ලීමක් පළ කරන්න',
        'ta':
            'தொழிலாளர்களிடமிருந்து ஏலங்களைப் பெற வேலை கோரிக்கையை இடுகையிடவும்',
      },
      'noHistory': {
        'en': 'No booking history',
        'si': 'වෙන්කිරීම් ඉතිහාසයක් නැත',
        'ta': 'முன்பதிவு வரலாறு இல்லை',
      },
      'noHistoryDesc': {
        'en': 'Your completed and cancelled bookings will appear here',
        'si': 'ඔබගේ සම්පූර්ණ කළ සහ අවලංගු කළ වෙන්කිරීම් මෙහි පෙන්වයි',
        'ta':
            'உங்கள் நிறைவு செய்யப்பட்ட மற்றும் ரத்து செய்யப்பட்ட முன்பதிவுகள் இங்கே தோன்றும்',
      },
      'accept': {'en': 'Accept', 'si': 'පිළිගන්න', 'ta': 'ஏற்றுக்கொள்'},
      'decline': {
        'en': 'Decline',
        'si': 'ප්‍රතික්ෂේප කරන්න',
        'ta': 'மறுக்கிறேன்',
      },
      'viewDetails': {
        'en': 'View Details',
        'si': 'විස්තර බලන්න',
        'ta': 'விவரங்களைக் காண்க',
      },
      'completed': {'en': 'Completed', 'si': 'සම්පූර්ණයි', 'ta': 'முடிந்தது'},
      'cancelled': {
        'en': 'Cancelled',
        'si': 'අවලංගු කළා',
        'ta': 'ரத்து செய்யப்பட்டது',
      },
      'pending': {'en': 'Pending', 'si': 'පොරොත්තුවෙන්', 'ta': 'நிலுவையில்'},
      'bookings': {'en': 'Bookings', 'si': 'වෙන්කිරීම්', 'ta': 'முன்பதிவுகள்'},
      'noAccepted': {
        'en': 'No accepted bids',
        'si': 'පිළිගත් ලංසු නැත',
        'ta': 'ஏற்றுக்கொள்ளப்பட்ட ஏலங்கள் இல்லை',
      },
      'noAcceptedDesc': {
        'en': 'Bids you accept will appear here until work is completed',
        'si': 'ඔබ පිළිගන්නා ලංසු වැඩ අවසන් වන තුරු මෙහි පෙන්වයි',
        'ta':
            'நீங்கள் ஏற்றுக்கொள்ளும் ஏலங்கள் வேலை முடியும் வரை இங்கே தோன்றும்',
      },
      'inProgress': {'en': 'In Progress', 'si': 'ප්‍රගතිය', 'ta': 'செயலில்'},
      'contactWorker': {
        'en': 'Contact Worker',
        'si': 'සේවකයා අමතන්න',
        'ta': 'பணியாளரை தொடர்பு கொள்ளுங்கள்',
      },
      'markComplete': {
        'en': 'Mark Complete',
        'si': 'සම්පූර්ණ ලෙස සලකුණු කරන්න',
        'ta': 'முடிந்ததாக குறிக்கவும்',
      },
    };
    return translations[key]?[widget.selectedLanguage] ??
        translations[key]?['en'] ??
        key;
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    return Scaffold(
      backgroundColor: t.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1533),
        foregroundColor: Colors.white,
        title: Text(_getTranslation('bookings')),
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          tabs: [
            Tab(icon: const Icon(Icons.gavel), text: _getTranslation('bids')),
            Tab(
              icon: const Icon(Icons.assignment_turned_in),
              text: _getTranslation('accepted'),
            ),
            Tab(
              icon: const Icon(Icons.history),
              text: _getTranslation('history'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BidsTab(theme: t, language: widget.selectedLanguage),
          _AcceptedBidsTab(theme: t, language: widget.selectedLanguage),
          _HistoryTab(theme: t, language: widget.selectedLanguage),
        ],
      ),
    );
  }
}

// ============================================================
// BIDS TAB
// ============================================================
class _BidsTab extends StatefulWidget {
  final AppTheme theme;
  final String language;

  const _BidsTab({required this.theme, required this.language});

  @override
  State<_BidsTab> createState() => _BidsTabState();
}

class _BidsTabState extends State<_BidsTab> {
  // Sample bids data
  final List<_Bid> _bids = [
    _Bid(
      id: '1',
      workerName: 'Sunil Perera',
      workerImage: '👷',
      workerType: 'Plumber',
      rating: 4.8,
      completedJobs: 150,
      bidAmount: 2500,
      estimatedTime: '2 hours',
      description:
          'I can fix your leaking pipe issue quickly. I have 10 years of experience.',
      jobTitle: 'Fix Kitchen Sink Leak',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: _BidStatus.pending,
    ),
    _Bid(
      id: '2',
      workerName: 'Kasun Silva',
      workerImage: '🔧',
      workerType: 'Electrician',
      rating: 4.5,
      completedJobs: 89,
      bidAmount: 3000,
      estimatedTime: '3 hours',
      description:
          'Professional electrical work with warranty. Available immediately.',
      jobTitle: 'Install Ceiling Fan',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      status: _BidStatus.pending,
    ),
    _Bid(
      id: '3',
      workerName: 'Nimal Fernando',
      workerImage: '🎨',
      workerType: 'Painter',
      rating: 4.9,
      completedJobs: 200,
      bidAmount: 15000,
      estimatedTime: '2 days',
      description:
          'High quality painting service. Will provide color consultation.',
      jobTitle: 'Paint Living Room',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      status: _BidStatus.pending,
    ),
  ];

  String _getTranslation(String key) {
    final translations = {
      'noBids': {
        'en': 'No active bids yet',
        'si': 'තවමත් ක්‍රියාකාරී ලංසු නැත',
        'ta': 'இன்னும் செயலில் உள்ள ஏலங்கள் இல்லை',
      },
      'noBidsDesc': {
        'en': 'Post a job request to start receiving bids from workers',
        'si': 'සේවකයන්ගෙන් ලංසු ලැබීම ආරම්භ කිරීමට රැකියා ඉල්ලීමක් පළ කරන්න',
        'ta':
            'தொழிலாளர்களிடமிருந்து ஏலங்களைப் பெற வேலை கோரிக்கையை இடுகையிடவும்',
      },
      'accept': {'en': 'Accept', 'si': 'පිළිගන්න', 'ta': 'ஏற்றுக்கொள்'},
      'decline': {
        'en': 'Decline',
        'si': 'ප්‍රතික්ෂේප කරන්න',
        'ta': 'மறுக்கிறேன்',
      },
      'jobs': {'en': 'jobs', 'si': 'රැකියා', 'ta': 'வேலைகள்'},
      'estimatedTime': {
        'en': 'Estimated time',
        'si': 'ඇස්තමේන්තුගත කාලය',
        'ta': 'மதிப்பிடப்பட்ட நேரம்',
      },
    };
    return translations[key]?[widget.language] ??
        translations[key]?['en'] ??
        key;
  }

  void _acceptBid(_Bid bid) {
    setState(() {
      final index = _bids.indexWhere((b) => b.id == bid.id);
      if (index != -1) {
        _bids[index] = bid.copyWith(status: _BidStatus.accepted);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.language == 'si'
              ? 'ලංසුව පිළිගන්නා ලදී! සේවකයා ඔබව ඉක්මනින් සම්බන්ධ කර ගනු ඇත.'
              : widget.language == 'ta'
              ? 'ஏலம் ஏற்றுக்கொள்ளப்பட்டது! பணியாளர் விரைவில் உங்களை தொடர்பு கொள்வார்.'
              : 'Bid accepted! Worker will contact you soon.',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _declineBid(_Bid bid) {
    setState(() {
      _bids.removeWhere((b) => b.id == bid.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.language == 'si'
              ? 'ලංසුව ප්‍රතික්ෂේප කරන ලදී'
              : widget.language == 'ta'
              ? 'ஏலம் நிராகரிக்கப்பட்டது'
              : 'Bid declined',
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeBids = _bids
        .where((b) => b.status == _BidStatus.pending)
        .toList();

    if (activeBids.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.gavel,
                size: 80,
                color: widget.theme.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                _getTranslation('noBids'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.theme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _getTranslation('noBidsDesc'),
                style: TextStyle(
                  fontSize: 14,
                  color: widget.theme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeBids.length,
      itemBuilder: (context, index) {
        final bid = activeBids[index];
        return _BidCard(
          bid: bid,
          theme: widget.theme,
          language: widget.language,
          onAccept: () => _acceptBid(bid),
          onDecline: () => _declineBid(bid),
          formatTimestamp: _formatTimestamp,
          getTranslation: _getTranslation,
        );
      },
    );
  }
}

// ============================================================
// BID CARD
// ============================================================
class _BidCard extends StatelessWidget {
  final _Bid bid;
  final AppTheme theme;
  final String language;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final String Function(DateTime) formatTimestamp;
  final String Function(String) getTranslation;

  const _BidCard({
    required this.bid,
    required this.theme,
    required this.language,
    required this.onAccept,
    required this.onDecline,
    required this.formatTimestamp,
    required this.getTranslation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job title
            Row(
              children: [
                Expanded(
                  child: Text(
                    bid.jobTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textPrimary,
                    ),
                  ),
                ),
                Text(
                  formatTimestamp(bid.timestamp),
                  style: TextStyle(fontSize: 12, color: theme.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Worker info
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1533).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      bid.workerImage,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bid.workerName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${bid.rating}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${bid.completedJobs} ${getTranslation('jobs')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Bid details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bid Amount',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textSecondary,
                        ),
                      ),
                      Text(
                        'LKR ${bid.bidAmount}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0B1533),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslation('estimatedTime'),
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textSecondary,
                        ),
                      ),
                      Text(
                        bid.estimatedTime,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              bid.description,
              style: TextStyle(
                fontSize: 14,
                color: theme.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      getTranslation('decline'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B1533),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      getTranslation('accept'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ACCEPTED BIDS TAB
// ============================================================
class _AcceptedBidsTab extends StatefulWidget {
  final AppTheme theme;
  final String language;

  const _AcceptedBidsTab({required this.theme, required this.language});

  @override
  State<_AcceptedBidsTab> createState() => _AcceptedBidsTabState();
}

class _AcceptedBidsTabState extends State<_AcceptedBidsTab> {
  // Sample accepted bids data (work in progress)
  final List<_AcceptedBid> _acceptedBids = [
    _AcceptedBid(
      id: '1',
      workerName: 'Sunil Perera',
      workerImage: '👷',
      workerType: 'Plumber',
      rating: 4.8,
      jobTitle: 'Fix Kitchen Sink Leak',
      bidAmount: 2500,
      estimatedTime: '2 hours',
      acceptedDate: DateTime.now().subtract(const Duration(days: 1)),
      scheduledDate: DateTime.now().add(const Duration(days: 1)),
      workerPhone: '+94 77 123 4567',
      status: _WorkStatus.inProgress,
    ),
    _AcceptedBid(
      id: '2',
      workerName: 'Kasun Silva',
      workerImage: '🔧',
      workerType: 'Electrician',
      rating: 4.5,
      jobTitle: 'Install Ceiling Fan',
      bidAmount: 3000,
      estimatedTime: '3 hours',
      acceptedDate: DateTime.now().subtract(const Duration(hours: 12)),
      scheduledDate: DateTime.now().add(const Duration(hours: 24)),
      workerPhone: '+94 71 987 6543',
      status: _WorkStatus.scheduled,
    ),
  ];

  String _getTranslation(String key) {
    final translations = {
      'noAccepted': {
        'en': 'No accepted bids',
        'si': 'පිළිගත් ලංසු නැත',
        'ta': 'ஏற்றுக்கொள்ளப்பட்ட ஏலங்கள் இல்லை',
      },
      'noAcceptedDesc': {
        'en': 'Bids you accept will appear here until work is completed',
        'si': 'ඔබ පිළිගන්නා ලංසු වැඩ අවසන් වන තුරු මෙහි පෙන්වයි',
        'ta':
            'நீங்கள் ஏற்றுக்கொள்ளும் ஏலங்கள் வேலை முடியும் வரை இங்கே தோன்றும்',
      },
      'inProgress': {'en': 'In Progress', 'si': 'ප්‍රගතියෙන්', 'ta': 'செயலில்'},
      'scheduled': {
        'en': 'Scheduled',
        'si': 'සැලසුම් කළා',
        'ta': 'திட்டமிடப்பட்டது',
      },
      'contactWorker': {
        'en': 'Contact Worker',
        'si': 'සේවකයා අමතන්න',
        'ta': 'பணியாளரை தொடர்பு கொள்ளுங்கள்',
      },
      'markComplete': {
        'en': 'Mark Complete',
        'si': 'සම්පූර්ණ ලෙස සලකුණු කරන්න',
        'ta': 'முடிந்ததாக குறிக்கவும்',
      },
      'acceptedOn': {
        'en': 'Accepted on',
        'si': 'පිළිගත් දිනය',
        'ta': 'ஏற்றுக்கொள்ளப்பட்ட தேதி',
      },
      'scheduledFor': {
        'en': 'Scheduled for',
        'si': 'සැලසුම් කළ දිනය',
        'ta': 'திட்டமிடப்பட்ட தேதி',
      },
    };
    return translations[key]?[widget.language] ??
        translations[key]?['en'] ??
        key;
  }

  void _markComplete(_AcceptedBid bid) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.theme.cardBackground,
        title: Text(
          widget.language == 'si'
              ? 'වැඩ අවසන්ද?'
              : widget.language == 'ta'
              ? 'வேலை முடிந்ததா?'
              : 'Work Completed?',
          style: TextStyle(color: widget.theme.textPrimary),
        ),
        content: Text(
          widget.language == 'si'
              ? 'මෙම වැඩ සාර්ථකව අවසන් වී ඇති බව තහවුරු කරන්නද?'
              : widget.language == 'ta'
              ? 'இந்த வேலை வெற்றிகரமாக முடிந்ததை உறுதிப்படுத்தவா?'
              : 'Confirm that this work has been completed successfully?',
          style: TextStyle(color: widget.theme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              widget.language == 'si'
                  ? 'අවලංගු කරන්න'
                  : widget.language == 'ta'
                  ? 'ரத்து செய்'
                  : 'Cancel',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _acceptedBids.removeWhere((b) => b.id == bid.id);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    widget.language == 'si'
                        ? 'වෙන්කිරීම සම්පූර්ණ කළා! ඉතිහාසයට එකතු කරන ලදි.'
                        : widget.language == 'ta'
                        ? 'முன்பதிவு முடிந்தது! வரலாற்றில் சேர்க்கப்பட்டது.'
                        : 'Booking completed! Added to history.',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0B1533),
            ),
            child: Text(
              widget.language == 'si'
                  ? 'තහවුරු කරන්න'
                  : widget.language == 'ta'
                  ? 'உறுதிப்படுத்து'
                  : 'Confirm',
            ),
          ),
        ],
      ),
    );
  }

  void _contactWorker(_AcceptedBid bid) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.language == 'si'
              ? 'අමතමින්: ${bid.workerPhone}'
              : widget.language == 'ta'
              ? 'அழைக்கிறது: ${bid.workerPhone}'
              : 'Calling: ${bid.workerPhone}',
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (_acceptedBids.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_turned_in,
                size: 80,
                color: widget.theme.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                _getTranslation('noAccepted'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.theme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _getTranslation('noAcceptedDesc'),
                style: TextStyle(
                  fontSize: 14,
                  color: widget.theme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _acceptedBids.length,
      itemBuilder: (context, index) {
        final bid = _acceptedBids[index];
        return _AcceptedBidCard(
          bid: bid,
          theme: widget.theme,
          language: widget.language,
          onContactWorker: () => _contactWorker(bid),
          onMarkComplete: () => _markComplete(bid),
          formatDate: _formatDate,
          getTranslation: _getTranslation,
        );
      },
    );
  }
}

// ============================================================
// ACCEPTED BID CARD
// ============================================================
class _AcceptedBidCard extends StatelessWidget {
  final _AcceptedBid bid;
  final AppTheme theme;
  final String language;
  final VoidCallback onContactWorker;
  final VoidCallback onMarkComplete;
  final String Function(DateTime) formatDate;
  final String Function(String) getTranslation;

  const _AcceptedBidCard({
    required this.bid,
    required this.theme,
    required this.language,
    required this.onContactWorker,
    required this.onMarkComplete,
    required this.formatDate,
    required this.getTranslation,
  });

  @override
  Widget build(BuildContext context) {
    final isInProgress = bid.status == _WorkStatus.inProgress;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job title and status
            Row(
              children: [
                Expanded(
                  child: Text(
                    bid.jobTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isInProgress
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    getTranslation(isInProgress ? 'inProgress' : 'scheduled'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isInProgress ? Colors.orange : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Worker info
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1533).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      bid.workerImage,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bid.workerName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${bid.rating}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            bid.workerType,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Bid details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textSecondary,
                        ),
                      ),
                      Text(
                        'LKR ${bid.bidAmount}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0B1533),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(color: theme.border),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslation('acceptedOn'),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.textSecondary,
                        ),
                      ),
                      Text(
                        formatDate(bid.acceptedDate),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getTranslation('scheduledFor'),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.textSecondary,
                        ),
                      ),
                      Text(
                        formatDate(bid.scheduledDate),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onContactWorker,
                    icon: const Icon(Icons.phone, size: 18),
                    label: Text(
                      getTranslation('contactWorker'),
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0B1533),
                      side: BorderSide(color: theme.border),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onMarkComplete,
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: Text(
                      getTranslation('markComplete'),
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HISTORY TAB
// ============================================================
class _HistoryTab extends StatelessWidget {
  final AppTheme theme;
  final String language;

  const _HistoryTab({required this.theme, required this.language});

  String _getTranslation(String key) {
    final translations = {
      'noHistory': {
        'en': 'No booking history',
        'si': 'වෙන්කිරීම් ඉතිහාසයක් නැත',
        'ta': 'முன்பதிவு வரலாறு இல்லை',
      },
      'noHistoryDesc': {
        'en': 'Your completed and cancelled bookings will appear here',
        'si': 'ඔබගේ සම්පූර්ණ කළ සහ අවලංගු කළ වෙන්කිරීම් මෙහි පෙන්වයි',
        'ta':
            'உங்கள் நிறைவு செய்யப்பட்ட மற்றும் ரத்து செய்யப்பட்ட முன்பதிவுகள் இங்கே தோன்றும்',
      },
      'completed': {'en': 'Completed', 'si': 'සම්පූර්ණයි', 'ta': 'முடிந்தது'},
      'cancelled': {
        'en': 'Cancelled',
        'si': 'අවලංගු කළා',
        'ta': 'ரத்து செய்யப்பட்டது',
      },
    };
    return translations[key]?[language] ?? translations[key]?['en'] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    // Sample history data
    final history = [
      _BookingHistory(
        id: '1',
        workerName: 'Anil Gunasekara',
        workerType: 'Plumber',
        jobTitle: 'Fixed Bathroom Leak',
        date: DateTime.now().subtract(const Duration(days: 5)),
        amount: 2000,
        status: _BookingStatus.completed,
      ),
      _BookingHistory(
        id: '2',
        workerName: 'Pradeep Jayasinghe',
        workerType: 'Electrician',
        jobTitle: 'Wiring Installation',
        date: DateTime.now().subtract(const Duration(days: 12)),
        amount: 5500,
        status: _BookingStatus.completed,
      ),
      _BookingHistory(
        id: '3',
        workerName: 'Chaminda Silva',
        workerType: 'Mason',
        jobTitle: 'Wall Construction',
        date: DateTime.now().subtract(const Duration(days: 20)),
        amount: 3000,
        status: _BookingStatus.cancelled,
      ),
    ];

    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 80,
                color: theme.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                _getTranslation('noHistory'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _getTranslation('noHistoryDesc'),
                style: TextStyle(fontSize: 14, color: theme.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final booking = history[index];
        return _HistoryCard(
          booking: booking,
          theme: theme,
          getTranslation: _getTranslation,
        );
      },
    );
  }
}

// ============================================================
// HISTORY CARD
// ============================================================
class _HistoryCard extends StatelessWidget {
  final _BookingHistory booking;
  final AppTheme theme;
  final String Function(String) getTranslation;

  const _HistoryCard({
    required this.booking,
    required this.theme,
    required this.getTranslation,
  });

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = booking.status == _BookingStatus.completed;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking.jobTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    getTranslation(isCompleted ? 'completed' : 'cancelled'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 18,
                  color: theme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  booking.workerName,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '• ${booking.workerType}',
                  style: TextStyle(fontSize: 14, color: theme.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: theme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(booking.date),
                  style: TextStyle(fontSize: 14, color: theme.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: theme.border),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 14, color: theme.textSecondary),
                ),
                Text(
                  'LKR ${booking.amount}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MODELS
// ============================================================
enum _BidStatus { pending, accepted, declined }

enum _BookingStatus { completed, cancelled, inProgress }

enum _WorkStatus { scheduled, inProgress, completed }

class _Bid {
  final String id;
  final String workerName;
  final String workerImage;
  final String workerType;
  final double rating;
  final int completedJobs;
  final int bidAmount;
  final String estimatedTime;
  final String description;
  final String jobTitle;
  final DateTime timestamp;
  final _BidStatus status;

  const _Bid({
    required this.id,
    required this.workerName,
    required this.workerImage,
    required this.workerType,
    required this.rating,
    required this.completedJobs,
    required this.bidAmount,
    required this.estimatedTime,
    required this.description,
    required this.jobTitle,
    required this.timestamp,
    required this.status,
  });

  _Bid copyWith({_BidStatus? status}) {
    return _Bid(
      id: id,
      workerName: workerName,
      workerImage: workerImage,
      workerType: workerType,
      rating: rating,
      completedJobs: completedJobs,
      bidAmount: bidAmount,
      estimatedTime: estimatedTime,
      description: description,
      jobTitle: jobTitle,
      timestamp: timestamp,
      status: status ?? this.status,
    );
  }
}

class _BookingHistory {
  final String id;
  final String workerName;
  final String workerType;
  final String jobTitle;
  final DateTime date;
  final int amount;
  final _BookingStatus status;

  const _BookingHistory({
    required this.id,
    required this.workerName,
    required this.workerType,
    required this.jobTitle,
    required this.date,
    required this.amount,
    required this.status,
  });
}

class _AcceptedBid {
  final String id;
  final String workerName;
  final String workerImage;
  final String workerType;
  final double rating;
  final String jobTitle;
  final int bidAmount;
  final String estimatedTime;
  final DateTime acceptedDate;
  final DateTime scheduledDate;
  final String workerPhone;
  final _WorkStatus status;

  const _AcceptedBid({
    required this.id,
    required this.workerName,
    required this.workerImage,
    required this.workerType,
    required this.rating,
    required this.jobTitle,
    required this.bidAmount,
    required this.estimatedTime,
    required this.acceptedDate,
    required this.scheduledDate,
    required this.workerPhone,
    required this.status,
  });
}
