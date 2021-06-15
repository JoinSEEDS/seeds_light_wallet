import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/v2/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/v2/screens/transfer/send/send_confirmation/interactor/viewmodels/send_info_line_items.dart';

class SendConfirmationState extends Equatable {
  final PageState pageState;
  final ShowTransactionSuccess? pageCommand;
  final String? errorMessage;
  final String account;
  final String name;
  final Map<String, dynamic> data;
  final List<SendInfoLineItems> lineItems;

  const SendConfirmationState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.account,
    required this.name,
    required this.lineItems,
    required this.data,
  });

  @override
  List<Object> get props => [pageState];

  SendConfirmationState copyWith({
    PageState? pageState,
    ShowTransactionSuccess? pageCommand,
    String? errorMessage,
    String? account,
    String? name,
    List<SendInfoLineItems>? lineItems,
    Map<String, dynamic>? data,
  }) {
    return SendConfirmationState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      account: account ?? this.account,
      name: name ?? this.name,
      lineItems: lineItems ?? this.lineItems,
      data: data ?? this.data,
    );
  }

  factory SendConfirmationState.initial(SendConfirmationArguments arguments) {
    return SendConfirmationState(
      pageState: PageState.initial,
      account: arguments.account,
      name: arguments.name,
      data: arguments.data,
      lineItems: [],
    );
  }
}
