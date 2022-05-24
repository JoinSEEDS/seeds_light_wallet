import 'dart:async';
import 'dart:convert';

import 'package:seeds/datasource/remote/api/polkadot/service/substrate_service.dart';

class ServiceStaking {
  ServiceStaking(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<Map?> queryElectedInfo() async {
    dynamic data = await serviceRoot.webView!.evalJavascript('staking.querySortedTargets(api)', allowRepeat: false);
    return data;
  }

  Future<Map?> queryNominations() async {
    dynamic data = await serviceRoot.webView!.evalJavascript('staking.queryNominations(api)', allowRepeat: false);
    return data;
  }

  Future<Map?> queryNominationsCount() async {
    dynamic data = await serviceRoot.webView!.evalJavascript('staking.queryNominationsCount(api)', allowRepeat: false);
    return data;
  }

  Future<List?> queryBonded(List<String> pubKeys) async {
    dynamic res = await serviceRoot.webView!.evalJavascript('account.queryAccountsBonded(api, ${jsonEncode(pubKeys)})');
    return res;
  }

  Future<Map?> queryOwnStashInfo(String accountId) async {
    dynamic data = await serviceRoot.webView!.evalJavascript('staking.getOwnStashInfo(api, "$accountId")');
    return data;
  }

  Future<Map?> loadValidatorRewardsData(String validatorId) async {
    dynamic data = await serviceRoot.webView!.evalJavascript('staking.loadValidatorRewardsData(api, "$validatorId")');
    return data;
  }

  Future<List?> getAccountRewardsEraOptions() async {
    final dynamic res = await serviceRoot.webView!.evalJavascript('staking.getAccountRewardsEraOptions(api)');
    return res;
  }

  // this query takes extremely long time
  Future<Map?> fetchAccountRewards(String address, int eras) async {
    final dynamic res =
        await serviceRoot.webView!.evalJavascript('staking.loadAccountRewardsData(api, "$address", $eras)');
    return res;
  }

  Future<int?> getSlashingSpans(String stashId) async {
    final dynamic spans = await serviceRoot.webView!.evalJavascript('staking.getSlashingSpans(api, "$stashId")');
    return spans;
  }
}
