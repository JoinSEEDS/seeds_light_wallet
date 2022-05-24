import 'dart:async';
import 'dart:convert';

import 'package:seeds/datasource/remote/api/polkadot/service/substrate_service.dart';

class ServiceTx {
  ServiceTx(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<Map?> estimateFees(Map txInfo, String params, {String? jsApi}) async {
    dynamic res = await serviceRoot.webView!.evalJavascript(
      'keyring.txFeeEstimate(${jsApi ?? 'api'}, ${jsonEncode(txInfo)}, $params)',
    );
    return res;
  }

//  Future<dynamic> _testSendTx() async {
//    Completer c = new Completer();
//    void onComplete(res) {
//      c.complete(res);
//    }
//
//    Timer(Duration(seconds: 6), () => onComplete({'hash': '0x79867'}));
//    return c.future;
//  }

  Future<Map?> signAndSend(Map txInfo, String params, password,
      Function(String) onStatusChange) async {
    final msgId =
        "onStatusChange${serviceRoot.webView!.getEvalJavascriptUID()}";
    serviceRoot.webView!.addMsgHandler(msgId, onStatusChange);
    final code =
        'keyring.sendTx(api, ${jsonEncode(txInfo)}, $params, "$password", "$msgId")';
    // print(code);
    final dynamic res = await serviceRoot.webView!.evalJavascript(code);
    serviceRoot.webView!.removeMsgHandler(msgId);

    return res;
  }
}
