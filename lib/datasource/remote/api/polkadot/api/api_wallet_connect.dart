
import 'package:seeds/datasource/remote/api/polkadot/api/polkawallet_api.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/walletConnect/pairingData.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/walletConnect/payloadData.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/wallet_connect.dart';

class ApiWalletConnect {
  ApiWalletConnect(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceWalletConnect service;

  void initClient(
    Function(WCPairingData) onPairing,
    Function(WCPairedData) onPaired,
    Function(WCPayloadData) onPayload,
  ) {
    service.initClient((Map proposal) {
      onPairing(WCPairingData.fromJson(proposal));
    }, (Map session) {
      onPaired(WCPairedData.fromJson(session));
    }, (Map payload) {
      onPayload(WCPayloadData.fromJson(payload));
    });
  }

  Future<Map?> connect(String uri) async {
    final Map? res = await service.connect(uri);
    return res;
  }

  Future<Map?> disconnect(Map params) async {
    return await service.disconnect(params);
  }

  Future<Map?> approvePairing(WCPairingData proposal, String address) async {
    final Map? res = await service.approvePairing(proposal.toJson(), address);
    return res;
  }

  Future<Map?> rejectPairing(WCPairingData proposal) async {
    final Map? res = await service.rejectPairing(proposal.toJson());
    return res;
  }

  Future<Map?> signPayload(WCPayloadData payload, String password) async {
    return await service.signPayload(payload.toJson(), password);
  }

  Future<Map?> payloadRespond(WCPayloadData payload,
      {Map? response, Map? error}) async {
    final Map? res = await service.payloadRespond({
      'topic': payload.topic,
      'response': {
        'id': payload.payload!.id,
        'jsonrpc': '2.0',
        'result': response,
        'error': error,
      }
    });
    return res;
  }
}
