import 'package:seeds/datasource/remote/api/polkadot/api/polkawallet_api.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/networkStateData.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/setting.dart';

class ApiSetting {
  ApiSetting(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceSetting? service;

  final _msgChannel = "BestNumber";

  /// query network const.
  Future<Map?> queryNetworkConst() async {
    final Map res = await service!.queryNetworkConst();
    return res;
  }

  /// query network properties.
  Future<NetworkStateData?> queryNetworkProps() async {
    final Map? res = await service!.queryNetworkProps();
    if (res == null) {
      return null;
    }
    return NetworkStateData.fromJson(res as Map<String, dynamic>);
  }

  /// subscribe best number.
  /// @return [String] msgChannel, call unsubscribeMessage(msgChannel) to unsub.
  Future<void> subscribeBestNumber(Function callback) async {
    await apiRoot.subscribeMessage(
      'api.derive.chain.bestNumber',
      [],
      _msgChannel,
      callback,
    );
  }

  Future<void> unsubscribeBestNumber() async {
    apiRoot.service.webView!.unsubscribeMessage(_msgChannel);
  }
}
