import 'dart:async';

import 'package:seeds/datasource/remote/api/polkadot/service/substrate_service.dart';

class ServiceSetting {
  ServiceSetting(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<Map?> queryNetwork() async {
    // fetch network info
    List res = await serviceRoot.webView!.evalJavascript(
        'Promise.all([settings.getNetworkProperties(api),api.rpc.system.chain(),settings.getNetworkConst(api)])');
    if (res[0] == null || res[1] == null || res[2] == null) {
      return null;
    }

    final Map props = {"props": res[0], "const": res[2]};
    props["props"]['name'] = res[1];
    return props;
  }

  Future<Map> queryNetworkConst() async {
    final dynamic res = await serviceRoot.webView!
        .evalJavascript('settings.getNetworkConst(api)');
    return res;
  }

  Future<Map?> queryNetworkProps() async {
    // fetch network info
    List res = await serviceRoot.webView!.evalJavascript(
        'Promise.all([settings.getNetworkProperties(api), api.rpc.system.chain()])');
    if (res[0] == null || res[1] == null) {
      return null;
    }

    final Map props = res[0];
    props['name'] = res[1];
    return props;
  }
}
