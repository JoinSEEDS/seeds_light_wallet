import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/fiat_rate_model.dart';
import 'package:seeds/v2/datasource/remote/model/rate_model.dart';

export 'package:async/src/result/result.dart';

// check here
class RatesRepository extends NetworkRepository {
  Future<Result> getFiatRates() {
    print("[http] get fiat rates");

    return http
        .get(Uri.parse("https://api-payment.hypha.earth/fiatExchangeRates?api_key=$fxApiKey"))
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return FiatRateModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getUSDRate() async {
    print('[http] get seeds rate USD');

    var request = '{"json":true,"code":"tlosto.seeds","scope":"tlosto.seeds","table":"price"}';

    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return RateModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
