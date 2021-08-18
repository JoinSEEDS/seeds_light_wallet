import 'package:seeds/components/amount_entry/interactor/viewmodels/amount_entry_state.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/ui_constants.dart';

String handleInfoRowText({
  required CurrencyInput currentCurrencyInput,
  required String fiatToSeeds,
  required String seedsToFiat,
}) {
  switch (currentCurrencyInput) {
    case CurrencyInput.fiat:
      return "$fiatToSeeds $currencySeedsCode";
    case CurrencyInput.seeds:
      return "$seedsToFiat ${settingsStorage.selectedFiatCurrency}";
  }
}
