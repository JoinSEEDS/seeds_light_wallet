import 'package:eosdart/eosdart.dart';
import 'package:eosdart/src/eosdart_base.dart';
import 'package:eosdart/src/serialize.dart' as ser;

Future<Contract> getContract(String accountName, AbiResp abi) async {
  var types = ser.getTypesFromAbi(ser.createInitialTypes(), abi.abi);

  var actions = new Map<String, Type>();

  for (var act in abi.abi.actions) {
    actions[act.name] = ser.getType(types, act.type);
  }

  var result = Contract(types, actions);

  return result;
}