import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_smart_contract_accounts.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/model/planted_model.dart';
import 'package:seeds/datasource/remote/model/refund_model.dart';

class PlantedRepository extends HttpRepository {
  Future<Result<PlantedModel>> getPlanted(String userAccount) {
    print('[http] get seeds getPlanted $userAccount');

    final plantedURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
        code: SeedsCode.accountHarvest,
        scope: SeedsCode.accountHarvest.value,
        table: SeedsTable.tableBalances,
        lowerBound: userAccount,
        upperBound: userAccount);

    return http
        .post(plantedURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<PlantedModel>(response, (dynamic body) {
              return PlantedModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<List<RefundModel>>> getRefunds(String userAccount) {
    print('[http] get seeds getRefunds $userAccount');

    final plantedURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: SeedsCode.accountHarvest,
      scope: userAccount,
      table: SeedsTable.tableRefunds,
      limit: 1000,
    );

    return http
        .post(plantedURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<RefundModel>>(response, (dynamic body) {
              final List<dynamic> allRefunds = body['rows'].toList();
              return allRefunds.map((item) => RefundModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }
}
