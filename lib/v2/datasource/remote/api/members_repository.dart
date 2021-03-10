import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class MembersRepository extends NetworkRepository {
  Future<Result> getMembers() {
    print('[http] get members');

    final membersURL = '$baseURL/v1/chain/get_table_rows';
    var request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":null,"upper_bound":null,"index_position":1,"key_type":"i64","limit":"1000","reverse":false,"show_payer":false}';

    return http
        .post(membersURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              List<dynamic> allAccounts = body['rows'].toList();
              return allAccounts.map((item) => MemberModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }
}
