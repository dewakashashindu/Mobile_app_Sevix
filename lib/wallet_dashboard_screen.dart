import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sevix/features/wallet/presentation/providers/wallet_provider.dart';

class WalletDashboardScreen extends ConsumerWidget {
  final String language;
  final VoidCallback onBack;

  const WalletDashboardScreen({
    super.key,
    required this.language,
    required this.onBack,
  });

  String _txt(String en, String si, String ta) {
    switch (language) {
      case 'si':
        return si;
      case 'ta':
        return ta;
      default:
        return en;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final notifier = ref.read(walletProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1533),
        foregroundColor: Colors.white,
        title: Text(_txt('Wallet', 'වොලට්', 'வாலெட்')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
          child: Column(
            children: [
              _BalanceCard(
                balance: wallet.balance,
                onTopUp: () => notifier.topUp(1000),
                title: _txt(
                  'Available Balance',
                  'පවතින ශේෂය',
                  'கிடைக்கும் இருப்பு',
                ),
                topUpLabel: _txt('Top Up', 'මුදල් එකතු කරන්න', 'பணம் சேர்க்க'),
              ),
              const SizedBox(height: 12),
              _EscrowTile(
                progress: wallet.escrowProgress,
                amount: wallet.activeEscrowAmount,
                title: _txt(
                  'Active Escrow',
                  'සක්රිය එස්ක්රෝ',
                  'செயலில் உள்ள எஸ்க்ரோ',
                ),
                subtitle: _txt(
                  'Funds release when job reaches 100%',
                  'කාර්යය 100% වූ විට මුදල් නිදහස් වේ',
                  'வேலை 100% ஆகும் போது நிதி விடுவிக்கப்படும்',
                ),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _txt('Transactions', 'ගනුදෙනු', 'பரிவர்த்தனைகள்'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF102243),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: wallet.transactions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final txn = wallet.transactions[index];
                    return _TransactionTile(transaction: txn);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  final String title;
  final String topUpLabel;
  final VoidCallback onTopUp;

  const _BalanceCard({
    required this.balance,
    required this.title,
    required this.topUpLabel,
    required this.onTopUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B1533), Color(0xFF173D7A), Color(0xFF4A85D8)],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330B1533),
            blurRadius: 26,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -28,
            right: -18,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -32,
            left: -20,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.86),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _RollingBalanceText(value: balance),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.17),
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: onTopUp,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add_circle_outline,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                topUpLabel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EscrowTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final double amount;

  const _EscrowTile({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6EDF7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lock_clock_outlined,
                  color: Color(0xFFE38B2C),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF102243),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6D7C95),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _money(amount),
                style: const TextStyle(
                  color: Color(0xFFE38B2C),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              backgroundColor: const Color(0xFFF0F3F8),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFE38B2C),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$percent% complete',
            style: const TextStyle(
              color: Color(0xFF6D7C95),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final iconConfig = _iconForType(transaction.type);
    final isCredit =
        transaction.type == WalletTransactionType.topUp ||
        transaction.type == WalletTransactionType.refund;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EDF6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0B1533),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconConfig.color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconConfig.icon, color: iconConfig.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: Color(0xFF122A4D),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _date(transaction.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF778899),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isCredit ? '+' : '-'}${_money(transaction.amount)}',
            style: TextStyle(
              color: isCredit ? const Color(0xFF1F9D57) : iconConfig.color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RollingBalanceText extends StatefulWidget {
  final double value;

  const _RollingBalanceText({required this.value});

  @override
  State<_RollingBalanceText> createState() => _RollingBalanceTextState();
}

class _RollingBalanceTextState extends State<_RollingBalanceText> {
  late String _current;

  @override
  void initState() {
    super.initState();
    _current = _money(widget.value);
  }

  @override
  void didUpdateWidget(covariant _RollingBalanceText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _current = _money(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'LKR ',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w700,
          ),
        ),
        ...List.generate(_current.length, (index) {
          final char = _current[index];
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 340),
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(0, -0.85),
                end: Offset.zero,
              ).animate(animation);
              return ClipRect(
                child: SlideTransition(
                  position: slide,
                  child: FadeTransition(opacity: animation, child: child),
                ),
              );
            },
            child: Text(
              char,
              key: ValueKey('$index-$char'),
              style: const TextStyle(
                fontSize: 36,
                height: 1,
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _TxnIcon {
  final IconData icon;
  final Color color;

  const _TxnIcon(this.icon, this.color);
}

_TxnIcon _iconForType(WalletTransactionType type) {
  switch (type) {
    case WalletTransactionType.topUp:
      return const _TxnIcon(Icons.add_circle_rounded, Color(0xFF1F9D57));
    case WalletTransactionType.refund:
      return const _TxnIcon(
        Icons.replay_circle_filled_rounded,
        Color(0xFF1F9D57),
      );
    case WalletTransactionType.payment:
      return const _TxnIcon(Icons.outbound_rounded, Color(0xFFE24D4D));
    case WalletTransactionType.escrow:
      return const _TxnIcon(Icons.lock_clock_rounded, Color(0xFFE38B2C));
  }
}

String _money(double value) {
  final fixed = value.toStringAsFixed(0);
  final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
  return fixed.replaceAll(reg, ',');
}

String _date(DateTime d) {
  final month = <String>[
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
  ][d.month - 1];
  final hour = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
  final suffix = d.hour >= 12 ? 'PM' : 'AM';
  final minute = d.minute.toString().padLeft(2, '0');
  return '$month ${d.day}, $hour:$minute $suffix';
}
