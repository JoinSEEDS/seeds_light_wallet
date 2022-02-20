part of 'send_confirmation_bloc.dart';

class SendConfirmationState extends Equatable {
  final PageState pageState;
  final TransactionPageCommand? pageCommand;
  final String? errorMessage;
  final EOSTransaction transaction;
  final TransactionResult transactionResult;
  final InvalidTransaction invalidTransaction;

  bool get isTransfer => transaction.isTransfer;

  const SendConfirmationState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.transaction,
    required this.transactionResult,
    required this.invalidTransaction,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        transaction,
        transactionResult,
        invalidTransaction,
      ];

  SendConfirmationState copyWith({
    PageState? pageState,
    TransactionPageCommand? pageCommand,
    String? errorMessage,
    EOSTransaction? transaction,
    TransactionResult? transactionResult,
    InvalidTransaction? invalidTransaction,
  }) {
    return SendConfirmationState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      transaction: transaction ?? this.transaction,
      transactionResult: transactionResult ?? this.transactionResult,
      invalidTransaction: invalidTransaction ?? this.invalidTransaction,
    );
  }

  factory SendConfirmationState.initial(SendConfirmationArguments arguments) {
    return SendConfirmationState(
      pageState: PageState.initial,
      transaction: arguments.transaction,
      transactionResult: const TransactionResult(),
      invalidTransaction: InvalidTransaction.none,
    );
  }
}

enum InvalidTransaction { none, insufficientBalance, alreadyInvited }
