part of 'invite_bloc.dart';

class InviteState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final InviteError? errorMessage;
  final RatesState ratesState;
  final bool isAutoFocus;
  final TokenDataModel tokenAmount;
  final FiatDataModel fiatAmount;
  final TokenDataModel? availableBalance;
  final FiatDataModel? availableBalanceFiat;
  final bool isCreateInviteButtonEnabled;
  final InviteError? alertMessage;
  final String? mnemonicSecretCode;
  final String? dynamicSecretLink;
  final bool showCloseDialogButton;

  const InviteState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.ratesState,
    required this.isAutoFocus,
    required this.tokenAmount,
    required this.fiatAmount,
    this.availableBalance,
    this.availableBalanceFiat,
    required this.isCreateInviteButtonEnabled,
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
        tokenAmount,
        alertMessage,
        showCloseDialogButton,
      ];

  InviteState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    InviteError? errorMessage,
    RatesState? ratesState,
    bool? isAutoFocus,
    TokenDataModel? tokenAmount,
    FiatDataModel? fiatAmount,
    TokenDataModel? availableBalance,
    FiatDataModel? availableBalanceFiat,
    bool? isCreateInviteButtonEnabled,
    InviteError? alertMessage,
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
      tokenAmount: tokenAmount ?? this.tokenAmount,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      availableBalance: availableBalance ?? this.availableBalance,
      availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
      isCreateInviteButtonEnabled: isCreateInviteButtonEnabled ?? this.isCreateInviteButtonEnabled,
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
      fiatAmount: FiatDataModel(0),
      isCreateInviteButtonEnabled: false,
      tokenAmount: TokenDataModel(0, token: seedsToken),
      showCloseDialogButton: false,
    );
  }
}
