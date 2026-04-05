import 'package:flutter/material.dart';
import 'main.dart' show AppTheme;
import 'package:sevix/l10n/app_localizations.dart';
import 'payment_checkout_screen.dart';

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
  final Set<String> _selectedBidIdsForCompare = <String>{};

  // Sample bids data
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
    _Bid(
      id: '4',
      requestId: 'req_002',
      workerName: 'Sahan Wickrama',
      workerImage: '💡',
      workerType: 'Electrician',
      rating: 4.9,
      completedJobs: 174,
      bidAmount: 3400,
      estimatedTime: '2 hours',
      description: 'Premium wiring finish with quick turnaround and clean-up.',
      jobTitle: 'Install Ceiling Fan',
      requestPostedAt: DateTime.now().subtract(const Duration(hours: 10)),
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      status: _BidStatus.pending,
    ),
  ];

  String _getTranslation(String key) {
    final l10n = AppLocalizations.of(context);

    switch (key) {
      case 'noBids':
        return l10n.noBids;
      case 'noBidsDesc':
        return l10n.noBidsDesc;
      case 'accept':
        return l10n.accept;
      case 'decline':
        return l10n.decline;
      case 'jobs':
        return l10n.jobs;
      case 'estimatedTime':
        return l10n.estimatedTime;
      case 'bidAmount':
        return l10n.bidAmount;
      default:
        return key;
    }
  }

  void _acceptBid(_Bid bid) {
    final scheduledDate = DateTime.now().add(const Duration(days: 1));

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.theme.cardBackground,
        title: Text(
          'Booking Confirmation',
          style: TextStyle(color: widget.theme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _summaryRow('Request', bid.jobTitle),
            const SizedBox(height: 6),
            _summaryRow('Worker', bid.workerName),
            const SizedBox(height: 6),
            _summaryRow('Amount', 'LKR ${bid.bidAmount}'),
            const SizedBox(height: 6),
            _summaryRow('Estimated Time', bid.estimatedTime),
            const SizedBox(height: 6),
            _summaryRow(
              'Scheduled',
              '${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var i = 0; i < _bids.length; i++) {
                  final current = _bids[i];
                  if (current.id == bid.id) {
                    _bids[i] = current.copyWith(status: _BidStatus.accepted);
                    continue;
                  }
                  if (current.requestId == bid.requestId &&
                      current.status == _BidStatus.pending) {
                    _bids[i] = current.copyWith(status: _BidStatus.declined);
                  }
                }
                _selectedBidIdsForCompare.clear();
              });

              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${AppLocalizations.of(context).bidAcceptedWorkerWillContact} Summary confirmed.',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0B1533),
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(
              color: widget.theme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: widget.theme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _counterBid(_Bid bid) {
    final amountController = TextEditingController(
      text: (bid.bidAmount - 200).toString(),
    );
    final noteController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.theme.cardBackground,
        title: Text(
          'Counter Bid',
          style: TextStyle(color: widget.theme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Your counter amount (LKR)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Message (optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final counterAmount = int.tryParse(amountController.text.trim());
              if (counterAmount == null || counterAmount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enter a valid counter amount.'),
                  ),
                );
                return;
              }

              setState(() {
                final index = _bids.indexWhere((b) => b.id == bid.id);
                if (index != -1) {
                  _bids[index] = _bids[index].copyWith(
                    status: _BidStatus.countered,
                    counterAmount: counterAmount,
                    counterNote: noteController.text.trim(),
                  );
                }
              });

              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Counter bid sent: LKR $counterAmount'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0B1533),
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Counter'),
          ),
        ],
      ),
    );
  }

  void _toggleCompareSelection(String bidId, bool selected) {
    setState(() {
      if (selected) {
        _selectedBidIdsForCompare.add(bidId);
      } else {
        _selectedBidIdsForCompare.remove(bidId);
      }
    });
  }

  void _showCompareDialog(List<_Bid> selectedBids) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.theme.cardBackground,
        title: Text(
          'Compare Bids',
          style: TextStyle(color: widget.theme.textPrimary),
        ),
        content: SizedBox(
          width: 620,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: selectedBids
                  .map(
                    (bid) => Container(
                      width: 220,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.theme.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: widget.theme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            bid.workerName,
                            style: TextStyle(
                              color: widget.theme.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            bid.workerType,
                            style: TextStyle(color: widget.theme.textSecondary),
                          ),
                          const Divider(height: 16),
                          Text('Bid: LKR ${bid.bidAmount}'),
                          Text('ETA: ${bid.estimatedTime}'),
                          Text('Rating: ${bid.rating}'),
                          Text('Jobs: ${bid.completedJobs}'),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _declineBid(_Bid bid) {
    setState(() {
      final index = _bids.indexWhere((b) => b.id == bid.id);
      if (index != -1) {
        _bids[index] = bid.copyWith(status: _BidStatus.declined);
      }
      _selectedBidIdsForCompare.remove(bid.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).bidDeclined)),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return AppLocalizations.of(context).minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return AppLocalizations.of(context).hoursAgo(difference.inHours);
    } else {
      return AppLocalizations.of(context).daysAgo(difference.inDays);
    }
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

    final selectedBids = activeBids
        .where((b) => _selectedBidIdsForCompare.contains(b.id))
        .toList();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.theme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.theme.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${selectedBids.length} selected for side-by-side comparison',
                  style: TextStyle(color: widget.theme.textSecondary),
                ),
              ),
              ElevatedButton.icon(
                onPressed: selectedBids.length >= 2
                    ? () => _showCompareDialog(selectedBids)
                    : null,
                icon: const Icon(Icons.compare_arrows),
                label: const Text('Compare'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B1533),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
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
                onCounter: () => _counterBid(bid),
                selectedForCompare: _selectedBidIdsForCompare.contains(bid.id),
                onCompareToggle: (selected) =>
                    _toggleCompareSelection(bid.id, selected),
                formatTimestamp: _formatTimestamp,
                getTranslation: _getTranslation,
              );
            },
          ),
        ),
      ],
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
  final VoidCallback onCounter;
  final bool selectedForCompare;
  final ValueChanged<bool> onCompareToggle;
  final String Function(DateTime) formatTimestamp;
  final String Function(String) getTranslation;

  const _BidCard({
    required this.bid,
    required this.theme,
    required this.language,
    required this.onAccept,
    required this.onDecline,
    required this.onCounter,
    required this.selectedForCompare,
    required this.onCompareToggle,
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
                Checkbox(
                  value: selectedForCompare,
                  onChanged: (value) => onCompareToggle(value ?? false),
                ),
              ],
            ),
            Text(
              'Request posted ${formatTimestamp(bid.requestPostedAt)}',
              style: TextStyle(fontSize: 12, color: theme.textSecondary),
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
                        getTranslation('bidAmount'),
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
            if (bid.counterAmount != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.swap_horiz, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Counter sent: LKR ${bid.counterAmount}${bid.counterNote != null && bid.counterNote!.isNotEmpty ? ' - ${bid.counterNote}' : ''}',
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                  child: OutlinedButton(
                    onPressed: onCounter,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0B1533),
                      side: const BorderSide(color: Color(0xFF0B1533)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Counter',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
    final l10n = AppLocalizations.of(context);

    switch (key) {
      case 'noAccepted':
        return l10n.noAccepted;
      case 'noAcceptedDesc':
        return l10n.noAcceptedDesc;
      case 'inProgress':
        return l10n.inProgress;
      case 'scheduled':
        return l10n.scheduled;
      case 'contactWorker':
        return l10n.contactWorker;
      case 'markComplete':
        return l10n.markComplete;
      case 'acceptedOn':
        return l10n.acceptedOn;
      case 'scheduledFor':
        return l10n.scheduledFor;
      case 'cancel':
        return l10n.cancel;
      case 'confirm':
        return l10n.confirm;
      case 'workCompletedTitle':
        return l10n.workCompletedTitle;
      case 'workCompletedQuestion':
        return l10n.workCompletedQuestion;
      case 'bookingCompletedAddedHistory':
        return l10n.bookingCompletedAddedHistory;
      case 'amount':
        return l10n.amount;
      default:
        return key;
    }
  }

  void _markComplete(_AcceptedBid bid) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.theme.cardBackground,
        title: Text(
          _getTranslation('workCompletedTitle'),
          style: TextStyle(color: widget.theme.textPrimary),
        ),
        content: Text(
          _getTranslation('workCompletedQuestion'),
          style: TextStyle(color: widget.theme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(_getTranslation('cancel')),
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
                    _getTranslation('bookingCompletedAddedHistory'),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0B1533),
            ),
            child: Text(_getTranslation('confirm')),
          ),
        ],
      ),
    );
  }

  void _contactWorker(_AcceptedBid bid) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).calling(bid.workerPhone)),
        backgroundColor: Colors.blue,
      ),
    );
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
          onPayNow: () => _openPayment(bid),
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
  final VoidCallback onPayNow;
  final VoidCallback onMarkComplete;
  final String Function(DateTime) formatDate;
  final String Function(String) getTranslation;

  const _AcceptedBidCard({
    required this.bid,
    required this.theme,
    required this.language,
    required this.onContactWorker,
    required this.onPayNow,
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
                        getTranslation('amount'),
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
                    onPressed: onPayNow,
                    icon: const Icon(Icons.payments_outlined, size: 18),
                    label: Text(
                      language == 'si'
                          ? 'ගෙවන්න'
                          : language == 'ta'
                          ? 'செலுத்து'
                          : 'Pay',
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B1533),
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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
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

  String _getTranslation(BuildContext context, String key) {
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
                _getTranslation(context, 'noHistory'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _getTranslation(context, 'noHistoryDesc'),
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
          getTranslation: (key) => _getTranslation(context, key),
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
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MODELS
// ============================================================
enum _BidStatus { pending, accepted, declined, countered }

enum _BookingStatus { completed, cancelled, inProgress }

enum _WorkStatus { scheduled, inProgress, completed }

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
  final int? counterAmount;
  final String? counterNote;

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
    this.counterAmount,
    this.counterNote,
  });

  _Bid copyWith({_BidStatus? status, int? counterAmount, String? counterNote}) {
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
      counterAmount: counterAmount ?? this.counterAmount,
      counterNote: counterNote ?? this.counterNote,
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
