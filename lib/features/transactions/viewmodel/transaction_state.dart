import '../model/transaction_model.dart';

sealed class TransactionState {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionLoaded extends TransactionState {
  const TransactionLoaded(this.transactions);
  final List<TransactionModel> transactions;
}

class TransactionError extends TransactionState {
  const TransactionError(this.message);
  final String message;
}
