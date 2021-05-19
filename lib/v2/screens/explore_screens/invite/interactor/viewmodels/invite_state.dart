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
  final bool showAlert;
  final bool showInviteLinkDialog;
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
    required this.showAlert,
    required this.showInviteLinkDialog,
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
        showAlert,
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
    bool? showAlert,
    bool? showInviteLinkDialog,
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
      showAlert: showAlert ?? this.showAlert,
      showInviteLinkDialog: showInviteLinkDialog ?? this.showInviteLinkDialog,
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
      showAlert: false,
      showInviteLinkDialog: false,
    );
  }
}
