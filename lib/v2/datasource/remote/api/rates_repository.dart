import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/fiat_rate_model.dart';
import 'package:seeds/v2/datasource/remote/model/rate_model.dart';

class RatesRepository extends NetworkRepository {
  Future<Result> getFiatRates() {
    print("[http] get fiat rates");

    return http
        .get("https://api.exchangeratesapi.io/latest?base=USD")
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return FiatRateModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getFiatRatesAlternate() async {
    print("[http] get alternate fiat rates");

    return http
        .get("http://data.fixer.io/api/latest?access_key=$fixerApiKey&symbols=CRC,GTQ,USD")
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return FiatRateModel.fromJsonFixer(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getUSDRate() async {
    print('[http] get seeds rate USD');

    var request = '{"json":true,"code":"tlosto.seeds","scope":"tlosto.seeds","table":"price"}';

    return http
        .post('$baseURL/v1/chain/get_table_rows', headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return RateModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
