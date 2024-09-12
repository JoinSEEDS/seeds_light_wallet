part of 'send_enter_data_bloc.dart';

class SendEnterDataState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final ProfileModel sendTo;
  final ProfileModel? sendFrom;
  final TokenDataModel tokenAmount;
  final FiatDataModel? fiatAmount;
  final RatesState ratesState;
  final TokenDataModel? availableBalance;
  final FiatDataModel? availableBalanceFiat;
  final bool isNextButtonEnabled;
  final String memo;
  final bool shouldAutoFocusEnterField;
  final bool showAlert;
  final bool showSendingAnimation;

  const SendEnterDataState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.sendTo,
    this.sendFrom,
    this.fiatAmount,
    required this.ratesState,
    this.availableBalance,
    this.availableBalanceFiat,
    required this.isNextButtonEnabled,
    required this.tokenAmount,
    required this.memo,
    required this.shouldAutoFocusEnterField,
    required this.showAlert,
    required this.showSendingAnimation,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        sendTo,
        sendFrom,
        fiatAmount,
        ratesState,
        availableBalance,
        availableBalanceFiat,
        isNextButtonEnabled,
        tokenAmount,
        memo,
        shouldAutoFocusEnterField,
        showAlert,
        showSendingAnimation,
      ];

  SendEnterDataState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    ProfileModel? sendTo,
    ProfileModel? sendFrom,
    FiatDataModel? fiatAmount,
    RatesState? ratesState,
    TokenDataModel? availableBalance,
    FiatDataModel? availableBalanceFiat,
    bool? isNextButtonEnabled,
    TokenDataModel? tokenAmount,
    String? memo,
    bool? shouldAutoFocusEnterField,
    bool? showAlert,
    bool? showSendingAnimation,
  }) {
    return SendEnterDataState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      sendTo: sendTo ?? this.sendTo,
      sendFrom: sendFrom ?? this.sendFrom,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      ratesState: ratesState ?? this.ratesState,
      availableBalance: availableBalance ?? this.availableBalance,
      availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
      isNextButtonEnabled: isNextButtonEnabled ?? this.isNextButtonEnabled,
      tokenAmount: tokenAmount ?? this.tokenAmount,
      memo: memo ?? this.memo,
      shouldAutoFocusEnterField: shouldAutoFocusEnterField ?? this.shouldAutoFocusEnterField,
      showAlert: showAlert ?? this.showAlert,
      showSendingAnimation: showSendingAnimation ?? this.showSendingAnimation,
    );
  }

  factory SendEnterDataState.initial(Map<String, ProfileModel> memberModels, RatesState ratesState,) {
    return SendEnterDataState(
      pageState: PageState.initial,
      sendTo: memberModels["to"]!,
      sendFrom: memberModels["from"],
      ratesState: ratesState,
      isNextButtonEnabled: false,
      tokenAmount: TokenDataModel(0, token: settingsStorage.selectedToken),
      memo: '',
      shouldAutoFocusEnterField: true,
      showAlert: false,
      showSendingAnimation: false,
    );
  }
}
