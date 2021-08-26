import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
// import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class SendEnterDataPageState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final MemberModel sendTo;
  final TokenDataModel quantity;
  final FiatDataModel? fiatAmount;
  final RatesState ratesState;
  final TokenDataModel? availableBalance;
  final FiatDataModel? availableBalanceFiat;
  final bool isNextButtonEnabled;
  final String memo;
  final bool shouldAutoFocusEnterField;
  final bool showAlert;
  final bool showSendingAnimation;

  const SendEnterDataPageState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.sendTo,
    this.fiatAmount,
    required this.ratesState,
    this.availableBalance,
    this.availableBalanceFiat,
    required this.isNextButtonEnabled,
    required this.quantity,
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
        fiatAmount,
        ratesState,
        availableBalance,
        availableBalanceFiat,
        isNextButtonEnabled,
        quantity,
        memo,
        shouldAutoFocusEnterField,
        showAlert,
        showSendingAnimation,
      ];

  SendEnterDataPageState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    MemberModel? sendTo,
    FiatDataModel? fiatAmount,
    RatesState? ratesState,
    TokenDataModel? availableBalance,
    FiatDataModel? availableBalanceFiat,
    bool? isNextButtonEnabled,
    TokenDataModel? quantity,
    String? memo,
    bool? shouldAutoFocusEnterField,
    bool? showAlert,
    bool? showSendingAnimation,
  }) {
    return SendEnterDataPageState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      sendTo: sendTo ?? this.sendTo,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      ratesState: ratesState ?? this.ratesState,
      availableBalance: availableBalance ?? this.availableBalance,
      availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
      isNextButtonEnabled: isNextButtonEnabled ?? this.isNextButtonEnabled,
      quantity: quantity ?? this.quantity,
      memo: memo ?? this.memo,
      shouldAutoFocusEnterField: shouldAutoFocusEnterField ?? this.shouldAutoFocusEnterField,
      showAlert: showAlert ?? this.showAlert,
      showSendingAnimation: showSendingAnimation ?? this.showSendingAnimation,
    );
  }

  factory SendEnterDataPageState.initial(MemberModel memberModel, RatesState ratesState) {
    return SendEnterDataPageState(
      pageState: PageState.initial,
      sendTo: memberModel,
      ratesState: ratesState,
      isNextButtonEnabled: false,
      quantity: TokenDataModel(0, token: settingsStorage.selectedToken),
      memo: '',
      shouldAutoFocusEnterField: true,
      showAlert: false,
      showSendingAnimation: false,
    );
  }
}
