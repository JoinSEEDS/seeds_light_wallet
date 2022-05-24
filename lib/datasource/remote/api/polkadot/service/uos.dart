import 'dart:async';
import 'dart:convert';

import 'package:seeds/datasource/remote/api/polkadot/service/substrate_service.dart';

/// Steps to complete offline-signature as a cold-wallet:
/// 1. parseQrCode: parse raw data of QR code, and get signer address from it.
/// 2. signAsync: sign the extrinsic with password, get signature.
/// 3. addSignatureAndSend: send tx with address of step1 & signature of step2.
///
/// Support offline-signature as a hot-wallet: makeQrCode
class ServiceUOS {
  ServiceUOS(this.serviceRoot);

  final SubstrateService serviceRoot;

  /// parse data of QR code.
  /// @return: { signer: <pubKey>, genesisHash: <genesisHash> } [Map]
  Future<Map<String, dynamic>> parseQrCode(List keyPairs, String data) async {
    final res = await serviceRoot.webView!
        .evalJavascript('keyring.parseQrCode("$data")');
    if (res['error'] != null) {
      throw Exception(res['error']);
    }

    final pubKeyAddressMap = await (serviceRoot.account
        .decodeAddress([res['signer']]) as FutureOr<Map<dynamic, dynamic>>);
    final pubKey = pubKeyAddressMap.keys.toList()[0];
    final accIndex = keyPairs.indexWhere((e) => e['pubKey'] == pubKey);
    if (accIndex < 0) {
      throw Exception('signer: ${res['signer']} not found.');
    }
    return Map<String, dynamic>.from({
      ...res,
      'signer': pubKey,
    });
  }

  /// this function must be called after parseQrCode.
  /// @return: signature [String]
  Future<String?> signAsync(String chain, password) async {
    final res = await serviceRoot.webView!
        .evalJavascript('keyring.signAsync("$chain", "$password")');
    if (res['error'] != null) {
      throw Exception(res['error']);
    }

    return res['signature'];
  }

  Future<Map?> addSignatureAndSend(
    String address,
    signed,
    Function(String) onStatusChange,
  ) async {
    final msgId =
        "onStatusChange${serviceRoot.webView!.getEvalJavascriptUID()}";
    serviceRoot.webView!.addMsgHandler(msgId, onStatusChange);

    final dynamic res = await serviceRoot.webView!.evalJavascript(
        'keyring.addSignatureAndSend(api, "$address", "$signed")');
    serviceRoot.webView!.removeMsgHandler(msgId);

    return res;
  }

  Future<Map?> makeQrCode(Map txInfo, List params,
      {String? rawParam, int? ss58}) async {
    String param = rawParam != null ? rawParam : jsonEncode(params);
    final dynamic res = await serviceRoot.webView!.evalJavascript(
      'keyring.makeTx(api, ${jsonEncode(txInfo)}, $param, $ss58)',
    );
    return res;
  }
}
