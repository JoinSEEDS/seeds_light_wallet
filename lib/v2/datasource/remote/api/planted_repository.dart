import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/planted_model.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class PlantedRepository extends NetworkRepository {
  Future<Result> getPlanted(String userAccount) {
    print('[http] get seeds getPlanted $userAccount');

    final plantedURL = '$baseURL/v1/chain/get_table_rows';
    var request =
        '{"json":true,"code":"harvst.seeds","scope":"harvst.seeds","table":"balances","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":100,"reverse":false,"show_payer":false}';

    return http
        .post(plantedURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return PlantedModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }
}
