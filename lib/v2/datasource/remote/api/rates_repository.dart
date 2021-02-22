import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/fiat_rate_model.dart';

class RatesRepository extends NetworkRepository {
  Future<Result> getFiatRates({@required String query}) {
    print("[http] get fiat rates");

    return http
        .get("https://api.exchangeratesapi.io/latest?base=$query")
        .then((http.Response response) => mapSuccess(response, (dynamic body) {
              return FiatRateModel.fromJson(body);
            }))
        .catchError((error) => mapError(error));
  }
}
