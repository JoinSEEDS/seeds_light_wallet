import 'dart:async';

import 'package:seeds/datasource/remote/api/polkadot/service/substrate_service.dart';

class ServiceRecovery {
  ServiceRecovery(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<Map?> queryRecoverable(String address) async {
//    address = "J4sW13h2HNerfxTzPGpLT66B3HVvuU32S6upxwSeFJQnAzg";
    dynamic res = await serviceRoot.webView!.evalJavascript('api.query.recovery.recoverable("$address")');
    if (res != null) {
      res['address'] = address;
    }
    return res;
  }

  Future<List> queryRecoverableList(List<String> addresses) async {
    final queries = addresses.map((e) => 'api.query.recovery.recoverable("$e")').toList();
    final dynamic ls = await serviceRoot.webView!.evalJavascript('Promise.all([${queries.join(',')}])');

    final res = [];
    ls.asMap().forEach((k, v) {
      if (v != null) {
        v['address'] = addresses[k];
      }
      res.add(v);
    });

    return res;
  }

  Future<List?> queryActiveRecoveryAttempts(String address, List<String> addressNew) async {
    List queries = addressNew.map((e) => 'api.query.recovery.activeRecoveries("$address", "$e")').toList();
    final res = await serviceRoot.webView!.evalJavascript('Promise.all([${queries.join(',')}])');
    return res;
  }

  Future<List?> queryActiveRecoveries(List<String> addresses, String addressNew) async {
    List queries = addresses.map((e) => 'api.query.recovery.activeRecoveries("$e", "$addressNew")').toList();
    final res = await serviceRoot.webView!.evalJavascript('Promise.all([${queries.join(',')}])');
    return res;
  }

  Future<List?> queryRecoveryProxies(List<String> addresses) async {
    List queries = addresses.map((e) => 'api.query.recovery.proxy("$e")').toList();
    final res = await serviceRoot.webView!.evalJavascript(
      'Promise.all([${queries.join(',')}])',
      allowRepeat: true,
    );
    return res;
  }
}
