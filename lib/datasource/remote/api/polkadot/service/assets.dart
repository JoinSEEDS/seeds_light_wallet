import 'dart:async';

import 'package:seeds/datasource/remote/api/polkadot/service/substrate_service.dart';

class ServiceAssets {
  ServiceAssets(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<List?> getAssetsAll() async {
    final dynamic res = await serviceRoot.webView!.evalJavascript('assets.getAssetsAll(api)');
    return res;
  }

  Future<List> queryAssetsBalances(List<String> ids, String address) async {
    final List res = await serviceRoot.webView!.evalJavascript('Promise.all(['
        '${ids.map((e) => 'api.query.assets.account($e, "$address")').join(',')}'
        '])');
    return res;
  }
}
