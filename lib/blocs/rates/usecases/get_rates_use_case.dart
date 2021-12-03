import 'dart:async';

import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/rates_repository.dart';

class GetRatesUseCase {
  final RatesRepository _ratesRepository = RatesRepository();

  Future<List<Result>> run() {
    final futures = [
      _ratesRepository.getSeedsRate(),
      _ratesRepository.getTelosRate(),
      _ratesRepository.getFiatRates(),
    ];
    return Future.wait(futures);
  }
}
