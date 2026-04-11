import 'package:flutter/material.dart';
import 'main.dart' show AppTheme;
import 'package:sevix/l10n/app_localizations.dart';
import 'payment_checkout_screen.dart';
import 'live_job_tracking_screen.dart';
import 'post_job_review_screen.dart';
import 'worker_profile_screen.dart';

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
  late final TabController _tabController;

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

  String _t(String en, String si, String ta) {
    switch (widget.selectedLanguage) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      default:
        return en;
    }
  }

  String _l10n(String key) {
    final l10n = AppLocalizations.of(context);
    switch (key) {
      case 'bids':
        return l10n.bids;
      case 'accepted':
        return l10n.accepted;
      case 'history':
        return l10n.history;
      case 'bookings':
        return l10n.bookings;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1533),
        foregroundColor: Colors.white,
        title: Text(_l10n('bookings')),
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(icon: const Icon(Icons.gavel), text: _l10n('bids')),
            Tab(
              icon: const Icon(Icons.assignment_turned_in),
              text: _l10n('accepted'),
            ),
            Tab(icon: const Icon(Icons.history), text: _l10n('history')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BidsTab(theme: theme, language: widget.selectedLanguage),
          _AcceptedBidsTab(theme: theme, language: widget.selectedLanguage),
          _HistoryTab(theme: theme, language: widget.selectedLanguage),
        ],
      ),
    );
  }
}

class _BidsTab extends StatefulWidget {
  final AppTheme theme;
  final String language;

  const _BidsTab({required this.theme, required this.language});

  @override
  State<_BidsTab> createState() => _BidsTabState();
}

class _BidsTabState extends State<_BidsTab> {
  final List<_Bid> _bids = [
    _Bid(
      id: '1',
      requestId: 'req_001',
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
      requestPostedAt: DateTime.now().subtract(const Duration(hours: 6)),
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      status: _BidStatus.pending,
    ),
    _Bid(
      id: '2',
      requestId: 'req_001',
      workerName: 'Tharindu Mendis',
      workerImage: '🧰',
      workerType: 'Plumber',
      rating: 4.7,
      completedJobs: 121,
      bidAmount: 2300,
      estimatedTime: '2.5 hours',
      description:
          'Can arrive within 30 minutes. Includes parts check and leak test.',
      jobTitle: 'Fix Kitchen Sink Leak',
      requestPostedAt: DateTime.now().subtract(const Duration(hours: 6)),
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      status: _BidStatus.pending,
    ),
    _Bid(
      id: '3',
      requestId: 'req_002',
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
      requestPostedAt: DateTime.now().subtract(const Duration(hours: 10)),
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      status: _BidStatus.pending,
    ),
  ];

  String _t(String en, String si, String ta) {
    switch (widget.language) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      default:
        return en;
    }
  }

  void _openProfile(_Bid bid) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WorkerProfileScreen(
          theme: widget.theme,
          language: widget.language,
          workerName: bid.workerName,
          workerType: bid.workerType,
          workerImage: bid.workerImage,
          rating: bid.rating,
          completedJobs: bid.completedJobs,
          trustScore: (bid.rating * 20).round().clamp(0, 100),
          skills: const [],
          certifications: const [],
          portfolioPhotos: const [],
          ratingBreakdown: const [],
          bidHistory: const [],
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _acceptBid(_Bid bid) {
    setState(() {
      for (var i = 0; i < _bids.length; i++) {
        final current = _bids[i];
        if (current.id == bid.id) {
          _bids[i] = current.copyWith(status: _BidStatus.accepted);
        } else if (current.requestId == bid.requestId &&
            current.status == _BidStatus.pending) {
          _bids[i] = current.copyWith(status: _BidStatus.declined);
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _t(
            'Bid accepted',
            'ලංසුව පිළිගන්නා ලදී',
            'ஏலம் ஏற்றுக்கொள்ளப்பட்டது',
          ),
        ),
      ),
    );
  }

  void _declineBid(_Bid bid) {
    setState(() {
      final index = _bids.indexWhere((b) => b.id == bid.id);
      if (index != -1) {
        _bids[index] = bid.copyWith(status: _BidStatus.declined);
      }
    });
  }

  void _counterBid(_Bid bid) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _t(
            'Counter bid sent',
            'ප්‍රතිලංසුව යවන ලදී',
            'எதிர் ஏலம் அனுப்பப்பட்டது',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeBids = _bids
        .where(
          (b) =>
              b.status == _BidStatus.pending ||
              b.status == _BidStatus.countered,
        )
        .toList();

    if (activeBids.isEmpty) {
      return Center(
        child: Text(
          _t('No bids yet', 'තවම ලංසු නැත', 'இதுவரை ஏலங்கள் இல்லை'),
          style: TextStyle(color: widget.theme.textSecondary),
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
          onOpenProfile: () => _openProfile(bid),
          onAccept: () => _acceptBid(bid),
          onDecline: () => _declineBid(bid),
          onCounter: () => _counterBid(bid),
        );
      },
    );
  }
}

class _BidCard extends StatelessWidget {
  final _Bid bid;
  final AppTheme theme;
  final String language;
  final VoidCallback onOpenProfile;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onCounter;

  const _BidCard({
    required this.bid,
    required this.theme,
    required this.language,
    required this.onOpenProfile,
    required this.onAccept,
    required this.onDecline,
    required this.onCounter,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.cardBackground,
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
                    bid.jobTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textPrimary,
                    ),
                  ),
                ),
                Text(
                  _formatTime(bid.timestamp),
                  style: TextStyle(color: theme.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Requested ${_formatTime(bid.requestPostedAt)}',
              style: TextStyle(fontSize: 12, color: theme.textSecondary),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: onOpenProfile,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFF0B1533).withOpacity(0.1),
                    child: Text(
                      bid.workerImage,
                      style: const TextStyle(fontSize: 24),
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
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${bid.rating}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: theme.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${bid.completedJobs} jobs',
                              style: TextStyle(color: theme.textSecondary),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right,
                              color: theme.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _row(theme, 'Bid', 'LKR ${bid.bidAmount}'),
                  const SizedBox(height: 8),
                  _row(theme, 'ETA', bid.estimatedTime),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              bid.description,
              style: TextStyle(color: theme.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDecline,
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCounter,
                    child: const Text('Counter'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(AppTheme theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: theme.textSecondary)),
        Text(
          value,
          style: TextStyle(
            color: theme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

class _AcceptedBidsTab extends StatefulWidget {
  final AppTheme theme;
  final String language;

  const _AcceptedBidsTab({required this.theme, required this.language});

  @override
  State<_AcceptedBidsTab> createState() => _AcceptedBidsTabState();
}

class _AcceptedBidsTabState extends State<_AcceptedBidsTab> {
  final List<_AcceptedBid> _acceptedBids = [
    _AcceptedBid(
      id: '1',
      workerId: 'worker_001',
      workerName: 'Sunil Perera',
      workerImage: '👷',
      workerType: 'Plumber',
      rating: 4.8,
      jobTitle: 'Fix Kitchen Sink Leak',
      bidAmount: 2500,
      acceptedDate: DateTime.now().subtract(const Duration(days: 1)),
      scheduledDate: DateTime.now().add(const Duration(days: 1)),
      workerPhone: '+94 77 123 4567',
      status: _WorkStatus.enRoute,
      submittedEtaMinutes: 24,
      customerLatitude: 6.9218,
      customerLongitude: 79.8597,
      chatId: 'chat_job_001',
    ),
    _AcceptedBid(
      id: '2',
      workerId: 'worker_002',
      workerName: 'Kasun Silva',
      workerImage: '🔧',
      workerType: 'Electrician',
      rating: 4.5,
      jobTitle: 'Install Ceiling Fan',
      bidAmount: 3000,
      acceptedDate: DateTime.now().subtract(const Duration(hours: 12)),
      scheduledDate: DateTime.now().add(const Duration(hours: 24)),
      workerPhone: '+94 71 987 6543',
      status: _WorkStatus.arrived,
      submittedEtaMinutes: 8,
      customerLatitude: 6.9350,
      customerLongitude: 79.8487,
      chatId: 'chat_job_002',
    ),
  ];

  void _openProfile(_AcceptedBid bid) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WorkerProfileScreen(
          theme: widget.theme,
          language: widget.language,
          workerName: bid.workerName,
          workerType: bid.workerType,
          workerImage: bid.workerImage,
          rating: bid.rating,
          completedJobs: (bid.rating * 36).round(),
          trustScore: (bid.rating * 20).round().clamp(0, 100),
          skills: const [],
          certifications: const [],
          portfolioPhotos: const [],
          ratingBreakdown: const [],
          bidHistory: const [],
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _markComplete(_AcceptedBid bid) {
    setState(() {
      _acceptedBids.removeWhere((b) => b.id == bid.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Work marked complete and added to history'),
      ),
    );
  }

  void _contactWorker(_AcceptedBid bid) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Calling ${bid.workerPhone}')));
  }

  Future<void> _openPayment(_AcceptedBid bid) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PaymentCheckoutScreen(
          theme: widget.theme,
          language: widget.language,
          jobTitle: bid.jobTitle,
          workerName: bid.workerName,
          amount: bid.bidAmount,
        ),
      ),
    );
  }

  Future<void> _openLiveTracking(_AcceptedBid bid) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LiveJobTrackingScreen(
          theme: widget.theme,
          language: widget.language,
          bookingId: bid.id,
          workerId: bid.workerId,
          workerName: bid.workerName,
          workerPhone: bid.workerPhone,
          jobTitle: bid.jobTitle,
          submittedEtaMinutes: bid.submittedEtaMinutes,
          customerLatitude: bid.customerLatitude,
          customerLongitude: bid.customerLongitude,
          chatId: bid.chatId,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
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
        child: Text(
          'No accepted jobs',
          style: TextStyle(color: widget.theme.textSecondary),
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
          onOpenProfile: () => _openProfile(bid),
          onContactWorker: () => _contactWorker(bid),
          onTrackLive: () => _openLiveTracking(bid),
          onPayNow: () => _openPayment(bid),
          onMarkComplete: () => _markComplete(bid),
          formatDate: _formatDate,
        );
      },
    );
  }
}

class _AcceptedBidCard extends StatelessWidget {
  final _AcceptedBid bid;
  final AppTheme theme;
  final String language;
  final VoidCallback onOpenProfile;
  final VoidCallback onContactWorker;
  final VoidCallback onTrackLive;
  final VoidCallback onPayNow;
  final VoidCallback onMarkComplete;
  final String Function(DateTime) formatDate;

  const _AcceptedBidCard({
    required this.bid,
    required this.theme,
    required this.language,
    required this.onOpenProfile,
    required this.onContactWorker,
    required this.onTrackLive,
    required this.onPayNow,
    required this.onMarkComplete,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final statusLabel = switch (bid.status) {
      _WorkStatus.enRoute => 'En Route',
      _WorkStatus.arrived => 'Arrived',
      _WorkStatus.inProgress => 'In Progress',
      _WorkStatus.scheduled => 'Scheduled',
      _WorkStatus.completed => 'Completed',
    };

    final statusColor = switch (bid.status) {
      _WorkStatus.enRoute => const Color(0xFF2563EB),
      _WorkStatus.arrived => const Color(0xFFF59E0B),
      _WorkStatus.inProgress => const Color(0xFF16A34A),
      _WorkStatus.scheduled => Colors.blue,
      _WorkStatus.completed => Colors.green,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.cardBackground,
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
                    bid.jobTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textPrimary,
                    ),
                  ),
                ),
                _StatusChip(label: statusLabel, color: statusColor),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: onOpenProfile,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFF0B1533).withOpacity(0.1),
                    child: Text(
                      bid.workerImage,
                      style: const TextStyle(fontSize: 24),
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
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${bid.rating}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: theme.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              bid.workerType,
                              style: TextStyle(color: theme.textSecondary),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right,
                              color: theme.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _row(theme, 'Amount', 'LKR ${bid.bidAmount}'),
                  const SizedBox(height: 8),
                  Divider(color: theme.border),
                  const SizedBox(height: 8),
                  _row(theme, 'Accepted', formatDate(bid.acceptedDate)),
                  const SizedBox(height: 4),
                  _row(theme, 'Scheduled', formatDate(bid.scheduledDate)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onContactWorker,
                    child: const Text('Contact'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onTrackLive,
                    icon: const Icon(Icons.near_me),
                    label: const Text('Track Live'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPayNow,
                    child: const Text('Pay'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onMarkComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Mark Complete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(AppTheme theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: theme.textSecondary)),
        Text(
          value,
          style: TextStyle(
            color: theme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HistoryTab extends StatefulWidget {
  final AppTheme theme;
  final String language;

  const _HistoryTab({required this.theme, required this.language});

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  late final List<_BookingHistory> _history;
  final Map<String, JobReviewSubmission> _reviewsByBookingId = {};

  @override
  void initState() {
    super.initState();
    _history = [
      _BookingHistory(
        id: '1',
        workerId: 'worker_003',
        workerName: 'Anil Gunasekara',
        workerType: 'Plumber',
        jobTitle: 'Fixed Bathroom Leak',
        date: DateTime.now().subtract(const Duration(days: 5)),
        amount: 2000,
        status: _BookingStatus.completed,
      ),
      _BookingHistory(
        id: '2',
        workerId: 'worker_004',
        workerName: 'Pradeep Jayasinghe',
        workerType: 'Electrician',
        jobTitle: 'Wiring Installation',
        date: DateTime.now().subtract(const Duration(days: 12)),
        amount: 5500,
        status: _BookingStatus.completed,
      ),
      _BookingHistory(
        id: '3',
        workerId: 'worker_005',
        workerName: 'Chaminda Silva',
        workerType: 'Mason',
        jobTitle: 'Wall Construction',
        date: DateTime.now().subtract(const Duration(days: 20)),
        amount: 3000,
        status: _BookingStatus.cancelled,
      ),
    ];
  }

  String _t(String en, String si, String ta) {
    switch (widget.language) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      default:
        return en;
    }
  }

  void _openProfile(BuildContext context, _BookingHistory booking) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WorkerProfileScreen(
          theme: widget.theme,
          language: widget.language,
          workerName: booking.workerName,
          workerType: booking.workerType,
          workerImage: booking.workerName,
          rating: booking.status == _BookingStatus.completed ? 4.8 : 4.4,
          completedJobs: booking.status == _BookingStatus.completed ? 118 : 96,
          trustScore: booking.status == _BookingStatus.completed ? 92 : 84,
          skills: const [],
          certifications: const [],
          portfolioPhotos: const [],
          ratingBreakdown: const [],
          bidHistory: const [],
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  Future<void> _openReview(_BookingHistory booking) async {
    final existingReview = _reviewsByBookingId[booking.id];
    final result = await Navigator.of(context).push<JobReviewSubmission>(
      MaterialPageRoute<JobReviewSubmission>(
        builder: (_) => PostJobReviewScreen(
          theme: widget.theme,
          language: widget.language,
          bookingId: booking.id,
          workerId: booking.workerId,
          workerName: booking.workerName,
          jobTitle: booking.jobTitle,
          existingReview: existingReview,
        ),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      _reviewsByBookingId[booking.id] = result;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _t(
            'Review submitted successfully',
            'සමාලෝචනය සාර්ථකව යවන ලදී',
            'மதிப்புரை வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final booking = _history[index];
        return _HistoryCard(
          booking: booking,
          theme: widget.theme,
          onOpenProfile: () => _openProfile(context, booking),
          onRate: booking.status == _BookingStatus.completed
              ? () => _openReview(booking)
              : null,
          review: _reviewsByBookingId[booking.id],
          getTranslation: (key) {
            final l10n = AppLocalizations.of(context);
            switch (key) {
              case 'noHistory':
                return l10n.noHistory;
              case 'noHistoryDesc':
                return l10n.noHistoryDesc;
              case 'completed':
                return l10n.completed;
              case 'cancelled':
                return l10n.cancelled;
              case 'totalAmount':
                return l10n.totalAmount;
              default:
                return key;
            }
          },
        );
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final _BookingHistory booking;
  final AppTheme theme;
  final VoidCallback onOpenProfile;
  final VoidCallback? onRate;
  final JobReviewSubmission? review;
  final String Function(String) getTranslation;

  const _HistoryCard({
    required this.booking,
    required this.theme,
    required this.onOpenProfile,
    required this.onRate,
    required this.review,
    required this.getTranslation,
  });

  String _formatDate(DateTime date) {
    const months = [
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
                _StatusChip(
                  label: getTranslation(
                    isCompleted ? 'completed' : 'cancelled',
                  ),
                  color: isCompleted ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: onOpenProfile,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFF0B1533).withOpacity(0.1),
                    child: Text(
                      booking.workerName.isNotEmpty
                          ? booking.workerName[0].toUpperCase()
                          : 'W',
                      style: const TextStyle(
                        color: Color(0xFF0B1533),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.workerName,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    booking.workerType,
                    style: TextStyle(fontSize: 14, color: theme.textSecondary),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: theme.textSecondary,
                  ),
                ],
              ),
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
                  getTranslation('totalAmount'),
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
            if (isCompleted) ...[
              const SizedBox(height: 14),
              if (review == null)
                FilledButton.icon(
                  onPressed: onRate,
                  icon: const Icon(Icons.rate_review_outlined),
                  label: const Text('Rate Worker'),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Rated ${review!.overallRating.toStringAsFixed(1)}/5.0',
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      TextButton(onPressed: onRate, child: const Text('Edit')),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

enum _BidStatus { pending, accepted, declined, countered }

enum _BookingStatus { completed, cancelled, inProgress }

enum _WorkStatus { scheduled, enRoute, arrived, inProgress, completed }

class _Bid {
  final String id;
  final String requestId;
  final String workerName;
  final String workerImage;
  final String workerType;
  final double rating;
  final int completedJobs;
  final int bidAmount;
  final String estimatedTime;
  final String description;
  final String jobTitle;
  final DateTime requestPostedAt;
  final DateTime timestamp;
  final _BidStatus status;

  const _Bid({
    required this.id,
    required this.requestId,
    required this.workerName,
    required this.workerImage,
    required this.workerType,
    required this.rating,
    required this.completedJobs,
    required this.bidAmount,
    required this.estimatedTime,
    required this.description,
    required this.jobTitle,
    required this.requestPostedAt,
    required this.timestamp,
    required this.status,
  });

  _Bid copyWith({_BidStatus? status}) {
    return _Bid(
      id: id,
      requestId: requestId,
      workerName: workerName,
      workerImage: workerImage,
      workerType: workerType,
      rating: rating,
      completedJobs: completedJobs,
      bidAmount: bidAmount,
      estimatedTime: estimatedTime,
      description: description,
      jobTitle: jobTitle,
      requestPostedAt: requestPostedAt,
      timestamp: timestamp,
      status: status ?? this.status,
    );
  }
}

class _BookingHistory {
  final String id;
  final String workerId;
  final String workerName;
  final String workerType;
  final String jobTitle;
  final DateTime date;
  final int amount;
  final _BookingStatus status;

  const _BookingHistory({
    required this.id,
    required this.workerId,
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
  final String workerId;
  final String workerName;
  final String workerImage;
  final String workerType;
  final double rating;
  final String jobTitle;
  final int bidAmount;
  final DateTime acceptedDate;
  final DateTime scheduledDate;
  final String workerPhone;
  final int submittedEtaMinutes;
  final double customerLatitude;
  final double customerLongitude;
  final String? chatId;
  final _WorkStatus status;

  const _AcceptedBid({
    required this.id,
    required this.workerId,
    required this.workerName,
    required this.workerImage,
    required this.workerType,
    required this.rating,
    required this.jobTitle,
    required this.bidAmount,
    required this.acceptedDate,
    required this.scheduledDate,
    required this.workerPhone,
    required this.submittedEtaMinutes,
    required this.customerLatitude,
    required this.customerLongitude,
    this.chatId,
    required this.status,
  });
}
