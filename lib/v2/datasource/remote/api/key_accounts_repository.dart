import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';

export 'package:async/src/result/error.dart';
export 'package:async/src/result/result.dart';

class KeyAccountsRepository extends NetworkRepository {
  Future<Result<dynamic>> getKeyAccountsMongo(String publicKey) {
    print('[http] get seeds getKeyAccountsMongo ');

    var body = '''
        {
          "collection": "pub_keys",
          "query": {
            "public_key": "$publicKey"\n    
          },
          "limit": 100
        }
        ''';

    return http
        .post(Uri.parse('https://mongo-api.hypha.earth/find'), headers: headers, body: body)
        .then((http.Response response) => mapSuccess(response, (dynamic body) {
              print('result: $body');

              var items = List<Map<String, dynamic>>.from(body['items'])
                  .where((item) => item['permission'] == 'active' || item['permission'] == 'owner');
              var result = items.map<String>((item) => item['account']).toSet().toList();

              result.sort();

              return result;
            }))
        .catchError((dynamic error) => mapError(error));
  }
}
