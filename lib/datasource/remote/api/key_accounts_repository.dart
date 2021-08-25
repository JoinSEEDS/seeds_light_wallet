import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/network_repository.dart';

class KeyAccountsRepository extends NetworkRepository {
  Future<Result<dynamic>> getKeyAccountsMongo(String publicKey) {
    print('[http] get seeds getKeyAccountsMongo ');

    final body = '''
        {
          "collection": "pub_keys",
          "query": {
            "public_key": "$publicKey"\n    
          },
          "limit": 100
        }
        ''';

    return http
        .post(Uri.parse(mongodbURL), headers: headers, body: body)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              print('result: $body');

              final items = List<Map<String, dynamic>>.from(body['items'])
                  .where((item) => item['permission'] == 'active' || item['permission'] == 'owner');
              final result = items.map<String>((item) => item['account']).toSet().toList();

              result.sort();

              return result;
            }))
        .catchError((dynamic error) => mapHttpError(error));
  }
}
