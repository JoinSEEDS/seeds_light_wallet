import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/planted_model.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class PlantedRepository extends NetworkRepository {
  Future<Result> getPlanted(String userAccount) {
    print("[http] get seeds getPlanted $userAccount");

    String request =
        '{"json":true,"code":"harvst.seeds","scope":"harvst.seeds","table":"balances","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":100,"reverse":false,"show_payer":false}';

    return http
        .post(request, headers: headers, body: request)
        .then((http.Response response) => mapSuccess(response, (dynamic body) {
              print("getBalance Response success" + body.toString());
              return PlantedModel.fromJson(body);
            }))
        .catchError((error) => mapError(error));
  }
}
