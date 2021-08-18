import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_info_line_items.dart';

class SendConfirmationState extends Equatable {
  final PageState pageState;
  final TransactionPageCommand? pageCommand;
  final String? errorMessage;
  final String account;
  final String actionName;
  final Map<String, dynamic> data;
  final List<SendInfoLineItems> lineItems;

  bool get isTransfer => actionName == transfer_action;

  const SendConfirmationState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.account,
    required this.actionName,
    required this.lineItems,
    required this.data,
  });

  @override
  List<Object?> get props => [pageState, pageCommand, errorMessage, account, actionName, data];

  SendConfirmationState copyWith({
    PageState? pageState,
    TransactionPageCommand? pageCommand,
    String? errorMessage,
    String? account,
    String? actionName,
    List<SendInfoLineItems>? lineItems,
    Map<String, dynamic>? data,
    int? popsOnDone,
  }) {
    return SendConfirmationState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      account: account ?? this.account,
      actionName: actionName ?? this.actionName,
      lineItems: lineItems ?? this.lineItems,
      data: data ?? this.data,
    );
  }

  factory SendConfirmationState.initial(SendConfirmationArguments arguments) {
    return SendConfirmationState(
      pageState: PageState.initial,
      account: arguments.account,
      actionName: arguments.name,
      data: arguments.data,
      lineItems: [],
    );
  }
}
