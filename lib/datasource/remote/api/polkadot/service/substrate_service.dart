import 'dart:async';

import 'package:seeds/datasource/remote/api/polkadot/service/account.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/assets.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/gov.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/parachain.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/recovery.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/service_keyring.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/service_staking.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/setting.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/tx.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/uos.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/wallet_connect.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/web_view_runner.dart';
import 'package:seeds/datasource/remote/api/polkadot/storage/keyring.dart';

/// The service calling JavaScript API of `polkadot-js/api` directly
/// through [WebViewRunner], providing APIs for [PolkawalletApi].
class SubstrateService {
  late ServiceKeyring keyring;
  late ServiceSetting setting;
  late ServiceAccount account;
  late ServiceTx tx;

  late ServiceStaking staking;
  late ServiceGov gov;
  late ServiceParachain parachain;
  late ServiceAssets assets;
  late ServiceUOS uos;
  late ServiceRecovery recovery;

  late ServiceWalletConnect walletConnect;

  WebViewRunner? _web;

  WebViewRunner? get webView => _web;

  Future<void> init(
    Keyring keyringStorage, {
    WebViewRunner? webViewParam,
    Function? onInitiated,
    String? jsCode,
    Function? socketDisconnectedAction,
  }) async {
    keyring = ServiceKeyring(this);
    setting = ServiceSetting(this);
    account = ServiceAccount(this);
    tx = ServiceTx(this);
    staking = ServiceStaking(this);
    gov = ServiceGov(this);
    parachain = ServiceParachain(this);
    assets = ServiceAssets(this);
    uos = ServiceUOS(this);
    recovery = ServiceRecovery(this);

    walletConnect = ServiceWalletConnect(this);

    _web = webViewParam ?? WebViewRunner();
    await _web!.launch(keyring, keyringStorage, onInitiated,
        jsCode: jsCode, socketDisconnectedAction: socketDisconnectedAction);
  }
}
