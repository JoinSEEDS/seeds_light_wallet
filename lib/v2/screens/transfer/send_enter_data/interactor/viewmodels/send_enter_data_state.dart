import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SendEnterDataPageState extends Equatable {
  final PageState pageState;
  final String? error;
  final MemberModel sendTo;
  final String? fiatAmount;
  final RatesState ratesState;
  final BalanceModel? balance;
  final String? availableBalance;
  final String? availableBalanceFiat;
  final bool isNextButtonEnabled;
  final PageCommand? pageCommand;
  final double quantity;
  final String memo;
  final bool shouldAutoFocusEnterField;

  const SendEnterDataPageState({
    required this.pageState,
    this.error,
    required this.sendTo,
    this.fiatAmount,
    required this.ratesState,
    this.availableBalance,
    this.availableBalanceFiat,
    required this.isNextButtonEnabled,
    this.balance,
    required this.quantity,
    this.pageCommand,
    required this.memo,
    required this.shouldAutoFocusEnterField,
  });

  @override
  List<Object?> get props => [
        pageState,
        sendTo,
        fiatAmount,
        error,
        ratesState,
        availableBalance,
        availableBalanceFiat,
        isNextButtonEnabled,
        balance,
        quantity,
        pageCommand,
        memo,
        shouldAutoFocusEnterField
      ];

  SendEnterDataPageState copyWith({
    PageState? pageState,
    String? error,
    MemberModel? sendTo,
    String? fiatAmount,
    RatesState? ratesState,
    String? availableBalance,
    String? availableBalanceFiat,
    BalanceModel? balance,
    bool? isNextButtonEnabled,
    PageCommand? pageCommand,
    double? quantity,
    String? memo,
    bool? shouldAutoFocusEnterField,
  }) {
    return SendEnterDataPageState(
        pageState: pageState ?? this.pageState,
        error: error ?? this.error,
        sendTo: sendTo ?? this.sendTo,
        fiatAmount: fiatAmount ?? this.fiatAmount,
        ratesState: ratesState ?? this.ratesState,
        availableBalance: availableBalance ?? this.availableBalance,
        availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
        balance: balance ?? this.balance,
        isNextButtonEnabled: isNextButtonEnabled ?? this.isNextButtonEnabled,
        pageCommand: pageCommand,
        quantity: quantity ?? this.quantity,
        memo: memo ?? this.memo,
        shouldAutoFocusEnterField: shouldAutoFocusEnterField ?? this.shouldAutoFocusEnterField);
  }

  factory SendEnterDataPageState.initial(MemberModel memberModel, RatesState ratesState) {
    return SendEnterDataPageState(
        pageState: PageState.initial,
        sendTo: memberModel,
        ratesState: ratesState,
        isNextButtonEnabled: false,
        quantity: 0,
        memo: '',
        shouldAutoFocusEnterField: true);
  }
}
