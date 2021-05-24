import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// --- STATE
class InviteState extends Equatable {
  final PageState pageState;
  final RatesState ratesState;
  final bool isAutoFocus;
  final String fiatAmount;
  final BalanceModel? availableBalance;
  final String? availableBalanceFiat;
  final bool isCreateInviteButtonEnabled;
  final double quantity;
  final String? alertMessage;
  final bool showInviteLinkDialog;
  final String? mnemonicSecretCode;
  final String? dynamicSecretLink;
  final String? errorMessage;

  const InviteState({
    required this.pageState,
    required this.ratesState,
    required this.isAutoFocus,
    required this.fiatAmount,
    this.availableBalance,
    this.availableBalanceFiat,
    required this.isCreateInviteButtonEnabled,
    required this.quantity,
    this.alertMessage,
    required this.showInviteLinkDialog,
    this.mnemonicSecretCode,
    this.dynamicSecretLink,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        ratesState,
        isAutoFocus,
        fiatAmount,
        availableBalance,
        availableBalanceFiat,
        isCreateInviteButtonEnabled,
        quantity,
        alertMessage,
        showInviteLinkDialog,
        errorMessage,
      ];

  InviteState copyWith({
    PageState? pageState,
    RatesState? ratesState,
    bool? isAutoFocus,
    String? fiatAmount,
    BalanceModel? availableBalance,
    String? availableBalanceFiat,
    bool? isCreateInviteButtonEnabled,
    double? quantity,
    String? alertMessage,
    bool? showInviteLinkDialog,
    String? mnemonicSecretCode,
    String? dynamicSecretLink,
    String? errorMessage,
  }) {
    return InviteState(
      pageState: pageState ?? this.pageState,
      ratesState: ratesState ?? this.ratesState,
      isAutoFocus: isAutoFocus ?? this.isAutoFocus,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      availableBalance: availableBalance ?? this.availableBalance,
      availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
      isCreateInviteButtonEnabled: isCreateInviteButtonEnabled ?? this.isCreateInviteButtonEnabled,
      quantity: quantity ?? this.quantity,
      alertMessage: alertMessage,
      showInviteLinkDialog: showInviteLinkDialog ?? this.showInviteLinkDialog,
      mnemonicSecretCode: mnemonicSecretCode,
      dynamicSecretLink: dynamicSecretLink,
      errorMessage: errorMessage ?? this.errorMessage,
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
      showInviteLinkDialog: false,
    );
  }
}
