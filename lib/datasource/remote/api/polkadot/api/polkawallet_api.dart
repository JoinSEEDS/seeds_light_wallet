import 'dart:convert';

import 'package:seeds/datasource/remote/api/polkadot/api/api_account.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/api_assets.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/api_gov.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/api_keyring.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/api_parachain.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/api_recovery.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/api_setting.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/api_staking.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/api_tx.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/api_uos.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/api_wallet_connect.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/subscan_request_params.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/networkParams.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/substrate_service.dart';
import 'package:seeds/datasource/remote/api/polkadot/storage/keyring.dart';

/// The [PolkawalletApi] instance is the wrapper of `polkadot-js/api`.
/// It provides:
/// * [ApiKeyring] of npm package [@polkadot/keyring](https://www.npmjs.com/package/@polkadot/keyring)
/// * [ApiSetting], the [networkConst] and [networkProperties] of `polkadot-js/api`.
/// * [ApiAccount], for querying on-chain data of accounts, like balances or indices.
/// * [ApiTx], sign and send tx.
/// * [ApiStaking] and [ApiGov], the staking and governance module of substrate.
/// * [ApiUOS], provides the offline-signature ability of polkawallet.
/// * [ApiRecovery], the social-recovery module of Kusama network.
class PolkawalletApi {
  PolkawalletApi(this.service) {
    keyring = ApiKeyring(this, service.keyring);
    setting = ApiSetting(this, service.setting);
    account = ApiAccount(this, service.account);
    tx = ApiTx(this, service.tx);

    staking = ApiStaking(this, service.staking);
    gov = ApiGov(this, service.gov);
    parachain = ApiParachain(this, service.parachain);
    assets = ApiAssets(this, service.assets);
    uos = ApiUOS(this, service.uos);
    recovery = ApiRecovery(this, service.recovery);

    walletConnect = ApiWalletConnect(this, service.walletConnect);
  }

  final SubstrateService service;

  NetworkParams? _connectedNode;

  late ApiKeyring keyring;
  late ApiSetting setting;
  late ApiAccount account;
  late ApiTx tx;

  late ApiStaking staking;
  late ApiGov gov;
  late ApiParachain parachain;
  late ApiAssets assets;
  late ApiUOS uos;
  late ApiRecovery recovery;

  late ApiWalletConnect walletConnect;

  final SubScanApi subScan = SubScanApi();

  // void init() {
  //   keyring = ApiKeyring(this, service.keyring);
  //   setting = ApiSetting(this, service.setting);
  //   account = ApiAccount(this, service.account);
  //   tx = ApiTx(this, service.tx);

  //   staking = ApiStaking(this, service.staking);
  //   gov = ApiGov(this, service.gov);
  //   parachain = ApiParachain(this, service.parachain);
  //   assets = ApiAssets(this, service.assets);
  //   uos = ApiUOS(this, service.uos);
  //   recovery = ApiRecovery(this, service.recovery);

  //   walletConnect = ApiWalletConnect(this, service.walletConnect);
  // }

  NetworkParams? get connectedNode => _connectedNode;

  /// connect to a list of nodes, return null if connect failed.
  Future<NetworkParams?> connectNode(Keyring keyringStorage, List<NetworkParams> nodes) async {
    _connectedNode = null;
    final NetworkParams? res = await service.webView!.connectNode(nodes);
    if (res != null) {
      _connectedNode = res;

      // update indices of keyPairs after connect
      await keyring.updateIndicesMap(keyringStorage);
    }
    return res;
  }

  /// subscribe message.
  Future<void> subscribeMessage(
    String jsCall,
    List params,
    String channel,
    Function callback,
  ) async {
    await service.webView!.subscribeMessage(
      'settings.subscribeMessage($jsCall, ${jsonEncode(params)}, "$channel")',
      channel,
      callback,
    );
  }

  /// unsubscribe message.
  void unsubscribeMessage(String channel) {
    service.webView!.unsubscribeMessage(channel);
  }
}
