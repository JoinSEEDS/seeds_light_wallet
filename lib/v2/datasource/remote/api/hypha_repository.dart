import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/hypha_model.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class HyphaRepository extends NetworkRepository {
  Future<Result> getHyphaVoice(String userAccount) async {
    print('[http] get seeds getHypha $userAccount');
    final voiceURL = '$hyphaURL/v1/chain/get_table_rows';

    var request =
        '{"json":true,"code":"funds.seeds","scope":"funds.seeds","table":"voice","table_key":"","lower_bound":"$userAccount","upper_bound":"$userAccount","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';

    return http
        .post(voiceURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
      return HyphaModel.fromJson(body);
    }))
        .catchError((error) => mapHttpError(error));
  }

}
