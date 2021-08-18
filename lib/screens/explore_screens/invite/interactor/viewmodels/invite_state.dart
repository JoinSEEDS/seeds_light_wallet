import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class ShowInviteLinkView extends PageCommand {}

/// --- STATE
class InviteState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final RatesState ratesState;
  final bool isAutoFocus;
  final String fiatAmount;
  final BalanceModel? availableBalance;
  final String? availableBalanceFiat;
  final bool isCreateInviteButtonEnabled;
  final double quantity;
  final String? alertMessage;
  final String? mnemonicSecretCode;
  final String? dynamicSecretLink;
  final bool showCloseDialogButton;

  const InviteState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.ratesState,
    required this.isAutoFocus,
    required this.fiatAmount,
    this.availableBalance,
    this.availableBalanceFiat,
    required this.isCreateInviteButtonEnabled,
    required this.quantity,
    this.alertMessage,
    this.mnemonicSecretCode,
    this.dynamicSecretLink,
    required this.showCloseDialogButton,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        ratesState,
        isAutoFocus,
        fiatAmount,
        availableBalance,
        availableBalanceFiat,
        isCreateInviteButtonEnabled,
        quantity,
        alertMessage,
        showCloseDialogButton,
      ];

  InviteState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    RatesState? ratesState,
    bool? isAutoFocus,
    String? fiatAmount,
    BalanceModel? availableBalance,
    String? availableBalanceFiat,
    bool? isCreateInviteButtonEnabled,
    double? quantity,
    String? alertMessage,
    String? mnemonicSecretCode,
    String? dynamicSecretLink,
    bool? showCloseDialogButton,
  }) {
    return InviteState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      ratesState: ratesState ?? this.ratesState,
      isAutoFocus: isAutoFocus ?? this.isAutoFocus,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      availableBalance: availableBalance ?? this.availableBalance,
      availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
      isCreateInviteButtonEnabled: isCreateInviteButtonEnabled ?? this.isCreateInviteButtonEnabled,
      quantity: quantity ?? this.quantity,
      alertMessage: alertMessage,
      mnemonicSecretCode: mnemonicSecretCode ?? this.mnemonicSecretCode,
      dynamicSecretLink: dynamicSecretLink ?? this.dynamicSecretLink,
      showCloseDialogButton: showCloseDialogButton ?? this.showCloseDialogButton,
    );
  }

  factory InviteState.initial(RatesState ratesState) {
    return InviteState(
      pageState: PageState.initial,
      ratesState: ratesState,
      isAutoFocus: true,
      fiatAmount: 0.toString(),
      isCreateInviteButtonEnabled: false,
      quantity: 0,
      showCloseDialogButton: false,
    );
  }
}
