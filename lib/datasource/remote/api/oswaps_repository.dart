import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/oswap_model.dart';

class OswapsRepository extends HttpRepository {
  static const defaultPoolContract = 'oswapper1111';

  Future<Result<List<OswapAsset>>> getAssetList(
      {String poolContract = OswapsRepository.defaultPoolContract, int first = 0, void Function(bool, int?)? nextCallback}) {
    //void Function(bool, int?)? nextCallback;

    print('[http] get asset list at $poolContract skipping $first');

    final request = '''
      {
        "code": "$poolContract",
        "scope": "$poolContract",
        "table": "assetsa",
        "limit": 20,
        "lowerBound": $first,
        "json": true
      }
    ''' ;

    final url = Uri.parse('$baseURL/v1/chain/get_table_rows');
    final aboutMessage = 'get oswap asset list from $url';
    return http
        .post(url, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<OswapAsset>>(response, (Map<String, dynamic> body) {
                if (nextCallback != null) {
                  nextCallback(body['more'] as bool, int.parse(body['next_key'] as String));
                }
              var rv = body['rows'].map<OswapAsset?>((i) => OswapAsset.fromJson(i as Map<String, dynamic>))//.toList();
              .where((e) => e != null)
              .map<OswapAsset>((e) => (e as OswapAsset?)!).toList();
              return rv;
            }))
        .catchError((error) => mapHttpError(error, about: aboutMessage));
  }
  /*
  Future<Result<OswapPoolBalance>> getPoolBalance(
      {String poolContract = OswapsRepository.defaultPoolContract, String? tokenId, int? assetId}) {

    print('[http] get pool balance at $poolContract for ${tokenId??" "}{$assetId??""}');
      }
  */
}
