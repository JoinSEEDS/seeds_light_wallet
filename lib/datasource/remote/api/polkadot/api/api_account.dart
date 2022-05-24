import 'package:seeds/datasource/remote/api/polkadot/api/polkawallet_api.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/balanceData.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/account.dart';

class ApiAccount {
  ApiAccount(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceAccount service;

  /// encode addresses to publicKeys
  Future<Map?> encodeAddress(List<String> pubKeys) async {
    final int? ss58 = apiRoot.connectedNode!.ss58;
    final Map? res = await service.encodeAddress(pubKeys, [ss58]);
    if (res != null) {
      return res[ss58.toString()];
    }
    return null;
  }

  /// decode addresses to publicKeys
  Future<Map?> decodeAddress(List<String> addresses) async {
    return service.decodeAddress(addresses);
  }

  /// check address matches ss58Format
  Future<bool?> checkAddressFormat(String address, int ss58) async {
    return service.checkAddressFormat(address, ss58);
  }

  /// query balance
  Future<BalanceData?> queryBalance(String? address) async {
    final res = await service.queryBalance(address);
    return res != null ? BalanceData.fromJson(res as Map<String, dynamic>) : null;
  }

  /// subscribe balance
  /// @return [String] msgChannel, call unsubscribeMessage(msgChannel) to unsub.
  Future<String> subscribeBalance(
    String? address,
    Function(BalanceData) onUpdate,
  ) async {
    final msgChannel = 'Balance';
    final code = 'account.getBalance(api, "$address", "$msgChannel")';
    await apiRoot.service.webView!.subscribeMessage(code, msgChannel, (data) => onUpdate(BalanceData.fromJson(data)));
    return msgChannel;
  }

  /// unsubscribe balance
  void unsubscribeBalance() {
    final msgChannel = 'Balance';
    apiRoot.unsubscribeMessage(msgChannel);
  }

  /// Get on-chain account info of addresses
  Future<List?> queryIndexInfo(List addresses) async {
    if (addresses.isEmpty) {
      return [];
    }

    return service.queryIndexInfo(addresses);
  }

  /// query address with account index
  Future<String?> queryAddressWithAccountIndex(String index) async {
    final res = await service.queryAddressWithAccountIndex(index, apiRoot.connectedNode!.ss58);
    if (res != null) {
      return res[0];
    }
    return null;
  }

  /// Get icons of pubKeys
  /// return svg strings
  Future<List?> getPubKeyIcons(List<String> keys) async {
    if (keys.isEmpty) {
      return [];
    }
    return service.getPubKeyIcons(keys);
  }

  /// Get icons of addresses
  /// return svg strings
  Future<List?> getAddressIcons(List addresses) async {
    if (addresses.isEmpty) {
      return [];
    }
    return service.getAddressIcons(addresses);
  }
}
