// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:typed_data';

import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/crypto/eosdart/eosdart.dart' as eos;

class EOSSerializeUtils {
  /// serialize actions in a transaction

  static Future<void> serializeActions(int version, eos.Contract contract, esr.Action? action) async {
    if (action!.account!.isEmpty && action.name == 'identity' && action.data is esr.Identity) {
      action.data =
          // ignore: cast_nullable_to_non_nullable
          (action.data as esr.Identity).toBinary(esr.ESRConstants.signingRequestAbiType(version)['identity']!);
    } else {
      action.data = EOSSerializeUtils.serializeActionData(
        contract,
        action.account,
        action.name,
        action.data,
      );
    }
  }

  /// Deserialize action data. If `data` is a `string`, then it's assumed to be in hex. */
  static Object? deserializeActionData(int version, eos.Contract contract, String account, String? name, dynamic data,
      esr.TextEncoder? textEncoder, esr.TextDecoder? textDecoder) {
    final action = contract.actions[name];
    if (data is String) {
      // ignore: parameter_assignments
      data = eos.hexToUint8List(data);
    }
    if (action == null) {
      throw 'Unknown action ${name} in contract ${account}';
    }

    if (account.isEmpty && name == 'identity') {
      return esr.Identity.fromBinary(esr.ESRConstants.signingRequestAbiType(version)['identity']!, data);
    }

    final buffer = eos.SerialBuffer(data);
    return action.deserialize!(action, buffer);
  }

  /// Deserialize action. If `data` is a `string`, then it's assumed to be in hex. */
  static esr.Action deserializeAction(
      int version,
      eos.Contract contract,
      String account,
      String? name,
      List<esr.Authorization?>? authorization,
      dynamic data,
      esr.TextEncoder? textEncoder,
      esr.TextDecoder? textDecoder) {
    return esr.Action()
      ..account = account
      ..name = name
      ..authorization = authorization
      ..data =
          EOSSerializeUtils.deserializeActionData(version, contract, account, name, data, textEncoder, textDecoder);
  }

  /// Convert action data to serialized form (hex) */
  static String serializeActionData(eos.Contract contract, String? account, String? name, Object? data) {
    final action = contract.actions[name];
    if (action == null) {
      throw "Unknown action $name in contract $account";
    }
    final buffer = eos.SerialBuffer(Uint8List(0));
    action.serialize!(action, buffer, data);
    return eos.arrayToHex(buffer.asUint8List());
  }
}
