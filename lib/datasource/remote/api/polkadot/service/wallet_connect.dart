import 'dart:async';
import 'dart:convert';

import 'package:seeds/datasource/remote/api/polkadot/service/substrate_service.dart';

class ServiceWalletConnect {
  ServiceWalletConnect(this.serviceRoot);

  final SubstrateService serviceRoot;

  void initClient(Function(Map) onPairing, Function(Map) onPaired,
      Function(Map) onPayload) {
    serviceRoot.webView!.addMsgHandler("walletConnectPayload", onPayload);
    serviceRoot.webView!.addMsgHandler("walletConnectPairing", onPairing);
    serviceRoot.webView!.addMsgHandler("walletConnectCreated", onPaired);
    serviceRoot.webView!.evalJavascript('walletConnect.initClient()');
  }

  Future<Map?> connect(String uri) async {
    return await serviceRoot.webView!
        .evalJavascript('walletConnect.connect("$uri")');
  }

  Future<Map?> disconnect(Map params) async {
    final dynamic res = await serviceRoot.webView!
        .evalJavascript('walletConnect.disconnect(${jsonEncode(params)})');
    serviceRoot.webView!.removeMsgHandler("walletConnectPayload");
    serviceRoot.webView!.removeMsgHandler("walletConnectPairing");
    serviceRoot.webView!.removeMsgHandler("walletConnectCreated");
    return res;
  }

  Future<Map?> approvePairing(Map proposal, String address) async {
    final dynamic res = await serviceRoot.webView!.evalJavascript(
        'walletConnect.approveProposal(${jsonEncode(proposal)}, "$address")');
    return res;
  }

  Future<Map?> rejectPairing(Map proposal) async {
    final dynamic res = await serviceRoot.webView!.evalJavascript(
        'walletConnect.rejectProposal(${jsonEncode(proposal)})');
    return res;
  }

  Future<Map?> signPayload(Map payload, String password) async {
    final dynamic res = await serviceRoot.webView!.evalJavascript(
        'walletConnect.signPayload(api, ${jsonEncode(payload)}, "$password")');
    return res;
  }

  Future<Map?> payloadRespond(Map response) async {
    final dynamic res = await serviceRoot.webView!.evalJavascript(
        'walletConnect.payloadRespond(${jsonEncode(response)})');
    return res;
  }
}
