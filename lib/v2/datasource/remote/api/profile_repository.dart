import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class ProfileRepository extends NetworkRepository {
  Future<Result> getProfile(String userAccount) {
    print("[http] get seeds getProfile");

    final String profileURL = 'https://mainnet.telosusa.io/v1/chain/get_table_rows';
    String request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":1,"reverse":false,"show_payer":false}';

    return http
        .post(profileURL, headers: headers, body: request)
        .then((http.Response response) => mapSuccess(response, (dynamic body) {
              return ProfileModel.fromJson(body["rows"][0]);
            }))
        .catchError((error) => mapError(error));
  }
}
