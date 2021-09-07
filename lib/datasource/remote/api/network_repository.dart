import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/util/response_extension.dart';

abstract class NetworkRepository {
  String baseURL = remoteConfigurations.defaultEndPointUrl;
  String v2historyURL = remoteConfigurations.defaultV2EndPointUrl;
  String hyphaURL = remoteConfigurations.hyphaEndPoint;
  String fxApiKey = "thesecretapikey989";
  Map<String, String> headers = {'Content-type': 'application/json'};

  String tableBalances = 'balances';
  String tableGuards = 'guards';
  String tableHarvest = 'harvest';
  String tableInvites = 'invites';
  String tableMoonphases = 'moonphases';
  String tableProps = 'props';
  String tableReferendums = 'referendums';
  String tableRefs = 'refs';
  String tableSupport = 'support';
  String tableUsers = 'users';
  String tableVoice = 'voice';
  String tableVotes = 'votes';
  String tableRecover = 'recovers';
  String tableTotals = 'totals';

  Result mapHttpResponse(http.Response response, Function modelMapper) {
    switch (response.statusCode) {
      case 200:
        {
          print('Model Class: $modelMapper');
          final body = response.parseJson();
          return ValueResult(modelMapper(body));
        }
      default:
        print("network error: ${response.reasonPhrase}");
        return ErrorResult(NetworkError(response.statusCode));
    }
  }

  Result mapHttpError(error) {
    print('mapHttpError: $error');
    return ErrorResult(error);
  }

  String createRequest({
    required String code,
    required String scope,
    required String table,
    String lowerBound = "",
    String upperBound = "",
    String tableKey = "",
    String keyType = "i64",
    int indexPosition = 1,
    int limit = 1,
    bool reverse = false,
    bool showPayer = false,
  }) {
    final String request =
        '{"json": true, "code": "$code", "scope": "$scope", "table": "$table", "table_key":"$tableKey", "lower_bound": "$lowerBound", "upper_bound": "$upperBound", "index_position": "$indexPosition", "key_type": "$keyType", "limit": $limit, "reverse": $reverse, "show_payer":"$showPayer"}';

    return request;
  }
}

class NetworkError extends Error {
  int statusCode;

  NetworkError(this.statusCode);
}
