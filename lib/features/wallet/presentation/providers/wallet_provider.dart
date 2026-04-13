import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WalletTransactionType { topUp, refund, payment, escrow }

class WalletTransaction {
  final String id;
  final String title;
  final WalletTransactionType type;
  final double amount;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.type,
    required this.amount,
    required this.createdAt,
  });
}

class WalletState {
  final double balance;
  final double activeEscrowAmount;
  final double escrowProgress;
  final List<WalletTransaction> transactions;

  const WalletState({
    required this.balance,
    required this.activeEscrowAmount,
    required this.escrowProgress,
    required this.transactions,
  });

  WalletState copyWith({
    double? balance,
    double? activeEscrowAmount,
    double? escrowProgress,
    List<WalletTransaction>? transactions,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      activeEscrowAmount: activeEscrowAmount ?? this.activeEscrowAmount,
      escrowProgress: escrowProgress ?? this.escrowProgress,
      transactions: transactions ?? this.transactions,
    );
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((
  ref,
) {
  return WalletNotifier();
});

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier()
    : super(
        WalletState(
          balance: 12450,
          activeEscrowAmount: 3800,
          escrowProgress: 0.68,
          transactions: [
            WalletTransaction(
              id: 'txn-escrow-1',
              title: 'Escrow hold - Electrical repair',
              type: WalletTransactionType.escrow,
              amount: 3800,
              createdAt: DateTime.now().subtract(const Duration(hours: 1)),
            ),
            WalletTransaction(
              id: 'txn-topup-1',
              title: 'Wallet Top Up',
              type: WalletTransactionType.topUp,
              amount: 2500,
              createdAt: DateTime.now().subtract(const Duration(days: 1)),
            ),
            WalletTransaction(
              id: 'txn-payment-1',
              title: 'Plumbing service payment',
              type: WalletTransactionType.payment,
              amount: 4200,
              createdAt: DateTime.now().subtract(const Duration(days: 2)),
            ),
            WalletTransaction(
              id: 'txn-refund-1',
              title: 'Partial refund - Booking #SX231',
              type: WalletTransactionType.refund,
              amount: 1200,
              createdAt: DateTime.now().subtract(const Duration(days: 3)),
            ),
          ],
        ),
      );

  void topUp(double amount) {
    final transaction = WalletTransaction(
      id: 'txn-topup-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Wallet Top Up',
      type: WalletTransactionType.topUp,
      amount: amount,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      balance: state.balance + amount,
      transactions: [transaction, ...state.transactions],
    );
  }

  void updateEscrowProgress(double progress) {
    final clamped = progress.clamp(0.0, 1.0);
    state = state.copyWith(escrowProgress: clamped);
  }
}
