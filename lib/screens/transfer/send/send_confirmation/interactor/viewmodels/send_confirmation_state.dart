part of 'send_confirmation_bloc.dart';

class SendConfirmationState extends Equatable {
  final PageState pageState;
  final TransactionPageCommand? pageCommand;
  final String? errorMessage;
  final EOSTransaction transaction;

  bool get isTransfer => transaction.isTransfer;

  const SendConfirmationState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.transaction,
  });

  @override
  List<Object?> get props => [pageState, pageCommand, errorMessage, transaction];

  SendConfirmationState copyWith({
    PageState? pageState,
    TransactionPageCommand? pageCommand,
    String? errorMessage,
    EOSTransaction? transaction,
  }) {
    return SendConfirmationState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      transaction: transaction ?? this.transaction,
    );
  }

  factory SendConfirmationState.initial(SendConfirmationArguments arguments) {
    return SendConfirmationState(
      pageState: PageState.initial,
      transaction: arguments.transaction,
    );
  }
}
