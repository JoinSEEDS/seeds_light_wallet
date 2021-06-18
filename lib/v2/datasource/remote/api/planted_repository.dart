import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/planted_model.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class PlantedRepository extends NetworkRepository {
  Future<Result> getPlanted(String userAccount) {
    print('[http] get seeds getPlanted $userAccount');

    final plantedURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request = createRequest(
        code: account_harvest,
        scope: account_harvest,
        table: table_balances,
        lowerBound: userAccount,
        upperBound: userAccount,
        limit: 1);

    return http
        .post(plantedURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return PlantedModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
