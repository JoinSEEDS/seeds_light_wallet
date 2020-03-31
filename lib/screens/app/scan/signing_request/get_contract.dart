import 'package:eosdart/src/client.dart';
import 'package:eosdart/src/eosdart_base.dart';
import 'package:eosdart/src/serialize.dart' as ser;

var client = EOSClient('https://eos.greymass.com', 'v1');

Future<Contract> getContract(String accountName) async {
  var abi = await client.getRawAbi(accountName);

  var types = ser.getTypesFromAbi(ser.createInitialTypes(), abi.abi);

  var actions = new Map<String, Type>();

  for (var act in abi.abi.actions) {
    actions[act.name] = ser.getType(types, act.type);
  }

  var result = Contract(types, actions);

  return result;
}