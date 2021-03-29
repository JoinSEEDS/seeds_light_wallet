import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/rates_repository.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class GetFiatRatesUseCase {
  final RatesRepository _ratesRepository = RatesRepository();

  Future<List<Result>> run() {
    var futures = [
      _ratesRepository.getFiatRates(),
      _ratesRepository.getFiatRatesAlternate(),
    ];
    return Future.wait(futures);
  }

}
