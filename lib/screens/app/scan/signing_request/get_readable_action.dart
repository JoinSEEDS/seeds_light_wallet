import 'package:convert/convert.dart';
import 'package:eosdart/src/serialize.dart' as ser;

import './get_contract.dart';

Future<Map<String, dynamic>> getReadableAction(String account, String name, String data) async {
  var contract = await getContract(account);

  var action = contract.actions[name];

  var buffer = ser.SerialBuffer(hex.decode(data));

  var result = action.deserialize(action, buffer);

  return Map.from(result);
}