import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/rates/mappers/rates_state_mapper.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/datasource/local/models/rate.dart';
import 'package:seeds/v2/blocs/rates/usecases/get_rates_use_case.dart';

/// --- BLOC
class RatesBloc extends Bloc<RatesEvent, RatesState> with CurrencyConverter {
  DateTime lastUpdated = DateTime.now().subtract(const Duration(hours: 1));

  RatesBloc() : super(RatesState.initial());

  @override
  Stream<RatesState> mapEventToState(RatesEvent event) async* {
    if (event is FetchRates) {
      if (DateTime.now().isAfter(lastUpdated.add(const Duration(hours: 1)))) {
        var results = await GetRatesUseCase().run();
        yield RatesStateMapper().mapResultToState(state, results);
      }
    }
  }

  @override
  double seedsTo(double seedsValue, String currencySymbol) {
    var usdValue = state.rate?.toUSD(seedsValue) ?? 0;
    return state.fiatRate?.usdTo(usdValue, currencySymbol) ?? 0;
  }

  @override
  double toSeeds(double currencyValue, String currencySymbol) {
    var usdValue = state.fiatRate?.toUSD(currencyValue, currencySymbol) ?? 0;
    return state.rate?.toSeeds(usdValue) ?? 0;
  }

  String currencyString(double seedsAmount, String currencySymbol) {
    return seedsTo(seedsAmount, currencySymbol).fiatFormatted + ' ' + currencySymbol;
  }

  String seedsString(double currencyAmount, String currencySymbol) {
    return toSeeds(currencyAmount, currencySymbol).seedsFormatted + ' $SEEDS';
  }

  String amountToString(double amount, String currency, {bool asSeeds = false}) {
    if (state.rate == null || state.fiatRate == null) {
      return '';
    } else {
      if (state.pageState == PageState.failure) {
        return 'Exchange rate load error'.i18n;
      }
      return asSeeds ? seedsString(amount, currency) : currencyString(amount, currency);
    }
  }
}

const String SEEDS = 'SEEDS';
