import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_scopes.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/model/fiat_rate_model.dart';
import 'package:seeds/datasource/remote/model/rate_model.dart';

class RatesRepository extends HttpRepository {
  Future<Result<FiatRateModel>> getFiatRates() {
    print("[http] get fiat rates");

    return http
        .get(Uri.parse("https://api-payment.hypha.earth/fiatExchangeRates?api_key=$fxApiKey"))
        .then((response) => mapHttpResponse<FiatRateModel>(response, (body) => FiatRateModel.fromJson(body)))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<RateModel>> getSeedsRate() async {
    print('[http] get seeds rate USD');

    final request = '{"json":true,"code":"tlosto.seeds","scope":"tlosto.seeds","table":"price"}';

    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), body: request)
        .then((response) => mapHttpResponse<RateModel>(response, (body) => RateModel.fromSeedsJson(body)))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<RateModel>> getTelosRate() async {
    print('[http] get telos rate USD');

    final params = createRequest(
      code: SeedsCode.accountdelphioracle,
      scope: "tlosusd",
      table: SeedsTable.tableDatapoints,
      // ignore: avoid_redundant_argument_values
      limit: 1,
    );

    return http
        .post(Uri.parse('$baseURL/v1/chain/get_table_rows'), body: params)
        .then((response) => mapHttpResponse<RateModel>(response, (body) {
              return RateModel.fromOracleJson("eosio.token#TLOS", 4, body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
