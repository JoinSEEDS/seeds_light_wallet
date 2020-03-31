import './parse_request_path.dart';
import './get_readable_action.dart';

Future<Map<String, dynamic>> getReadableRequest(String uriPath) async {
  var signingRequest = parseRequestPath(uriPath);

  var action = signingRequest["req"][1][0];

  var account = action["account"];
  var name = action["name"];
  var data = action["data"];

  Map<String, dynamic> dataDecoded = await getReadableAction(account, name, data);

  return {
    "account": account,
    "action": name,
    "data": dataDecoded
  };
}