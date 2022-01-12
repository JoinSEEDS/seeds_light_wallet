part of 'send_confirmation_bloc.dart';

class SendConfirmationState extends Equatable {
  final PageState pageState;
  final TransactionPageCommand? pageCommand;
  final String? errorMessage;
  final EOSTransaction transaction;
  final TransactionResult transactionResult;

  bool get isTransfer => transaction.isTransfer;

  const SendConfirmationState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.transaction,
    required this.transactionResult,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        transaction,
        transactionResult,
      ];

  SendConfirmationState copyWith({
    PageState? pageState,
    TransactionPageCommand? pageCommand,
    String? errorMessage,
    EOSTransaction? transaction,
    TransactionResult? transactionResult,
  }) {
    return SendConfirmationState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      transaction: transaction ?? this.transaction,
      transactionResult: transactionResult ?? this.transactionResult,
    );
  }

  factory SendConfirmationState.initial(SendConfirmationArguments arguments) {
    return SendConfirmationState(
      pageState: PageState.initial,
      transaction: arguments.transaction,
      transactionResult: const TransactionResult(),
    );
  }
}
