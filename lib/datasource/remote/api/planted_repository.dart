import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/network_repository.dart';
import 'package:seeds/datasource/remote/model/planted_model.dart';
import 'package:seeds/datasource/remote/model/refund_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';

class PlantedRepository extends NetworkRepository {
  Future<Result> getPlanted(String userAccount) {
    print('[http] get seeds getPlanted $userAccount');

    final plantedURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
        code: accountHarvest,
        scope: accountHarvest,
        table: tableBalances,
        lowerBound: userAccount,
        upperBound: userAccount);

    return http
        .post(plantedURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return PlantedModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getRefunds(String userAccount) {
    print('[http] get seeds getRefunds $userAccount');

    final plantedURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    final request = createRequest(
      code: accountHarvest,
      scope: userAccount,
      table: tableRefunds,
      limit: 1000,
    );

    return http
        .post(plantedURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              final List<dynamic> allRefunds = body['rows'].toList();
              return allRefunds.map((item) => RefundModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }
}
