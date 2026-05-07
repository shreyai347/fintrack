import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fintrack/generated/database/app_database.dart';

import '../model/transaction_model.dart';
import '../repository/transaction_repository_impl.dart';
import '../../receipt/repository/receipt_repository_impl.dart';
import 'transaction_state.dart';

class TransactionNotifier extends Notifier<TransactionState> {
  StreamSubscription<List<TransactionModel>>? _sub;

  @override
  TransactionState build() {
    final repo = ref.read(transactionRepositoryProvider);
    ref.onDispose(() => _sub?.cancel());
    _sub?.cancel();
    _sub = repo.watchAll().listen(
      (list) => scheduleMicrotask(() => state = TransactionLoaded(list)),
      onError: (e, _) =>
          scheduleMicrotask(() => state = TransactionError(e.toString())),
    );
    return const TransactionLoading();
  }

  Future<void> addTransaction(TransactionsCompanion companion) async {
    try {
      await ref.read(transactionRepositoryProvider).add(companion);
    } catch (e) {
      state = TransactionError(e.toString());
    }
  }

  Future<void> updateTransaction(TransactionsCompanion companion) async {
    try {
      final ok =
          await ref.read(transactionRepositoryProvider).update(companion);
      if (!ok) state = TransactionError('Update failed');
    } catch (e) {
      state = TransactionError(e.toString());
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      final tx = await ref.read(transactionRepositoryProvider).getById(id);
      await ref.read(transactionRepositoryProvider).delete(id);
      await ref.read(receiptRepositoryProvider).deleteReceipt(tx?.receiptPath);
    } catch (e) {
      state = TransactionError(e.toString());
    }
  }

  void retry() {
    state = const TransactionLoading();
    _sub?.cancel();
    final repo = ref.read(transactionRepositoryProvider);
    _sub = repo.watchAll().listen(
      (list) => scheduleMicrotask(() => state = TransactionLoaded(list)),
      onError: (e, _) =>
          scheduleMicrotask(() => state = TransactionError(e.toString())),
    );
  }
}
