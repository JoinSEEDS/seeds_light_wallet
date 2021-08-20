import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/utils/double_extension.dart';

class TokenBalanceViewModel {
  final TokenModel token;
  final BalanceModel? balance;
  final bool errorLoading;

  const TokenBalanceViewModel(this.token, this.balance, {this.errorLoading = false});

  String get displayQuantity {
    if (errorLoading || balance == null) {
      return "...";
    } else {
      if (token.precision == 2) {
        return "${twoDigitNumberFormat.format(balance!.quantity)} ${token.symbol}";
      } else {
        return '${balance!.quantity.seedsFormatted}  ${token.symbol}';
      }
    }
  }

  /// Return a display string like "35.00 USD", or "" if conversion is impossible
  String fiatValueString(RatesState rateState) {
    final fiatCurrency = settingsStorage.selectedFiatCurrency;
    if (balance != null) {
      if (token == SeedsToken) {
        // Convert seeds to USD
        final double? usdValue = rateState.rate?.seedsToUSD(balance!.quantity);
        if (usdValue != null && rateState.fiatRate != null) {
          // Convert the seeds (USD amount) in the new currency
          final double? fiatValue = rateState.fiatRate?.usdToCurrency(usdValue, fiatCurrency);
          if (fiatValue != null) {
            return "${fiatValue.fiatFormatted} $fiatCurrency";
          }
        }
      }
    }
    return "";
  }
}
