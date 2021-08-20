import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class AmountViewModel {
  final double? amount;
  final String symbol;
  final bool fiat;
  final int precision;

  AmountViewModel({
    this.amount,
    required this.symbol,
    this.fiat = false,
    this.precision = 4,
  });

  factory AmountViewModel.fromToken(double? amount, {TokenModel token = SeedsToken}) {
    return AmountViewModel(
      amount: amount,
      symbol: token.symbol,
      precision: token.precision,
    );
  }

  factory AmountViewModel.fromFiat(double? amount, {String? fiatSymbol}) {
    return AmountViewModel(
      amount: amount,
      symbol: fiatSymbol ?? settingsStorage.selectedFiatCurrency,
      fiat: true,
      precision: 2,
    );
  }

  String asFormattedString() {
    if (amount != null) {
      return "${amount?.toStringAsFixed(precision)} $symbol";
    } else {
      return '';
    }
  }
}
