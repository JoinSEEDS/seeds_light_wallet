import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/api/rates_repository.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class GetFiatRatesUseCase {
  final RatesRepository _ratesRepository = RatesRepository();

  Future<Result> run({@required String query}) {
    return _ratesRepository.getFiatRates(query: query);
  }
}
