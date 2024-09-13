import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/model/eos_account_model.dart';

class EOSAccountRepository extends HttpRepository {
  Future<Result<EOSAccountModel>> getEOSAccount(String accountName) {
    print('[http] get getAccount $accountName');

    final String request = '''
    {
      "account_name":"$accountName",
    }
    ''';

    final getAccountURL = Uri.parse('$baseURL/v1/chain/get_account');
    final aboutMessage = 'getAccount from $getAccountURL';
    return http
        .post(getAccountURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<EOSAccountModel>(response, (dynamic body) {
              return EOSAccountModel.fromJson(body);
            },
            about: aboutMessage))
        .catchError((dynamic error) => mapHttpError(error, about: aboutMessage));
  }
}
