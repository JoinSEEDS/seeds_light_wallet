import 'dart:async';

import 'package:seeds/datasource/remote/api/polkadot/api/polkawallet_api.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/staking/accountBondedInfo.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/staking/ownStashInfo.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/service_staking.dart';

class ApiStaking {
  ApiStaking(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceStaking service;

  Future<Map?> queryElectedInfo() async {
    final Map? data = await service.queryElectedInfo();
    return data;
  }

  Future<Map?> queryNominations() async {
    final res = await service.queryNominations();
    return res;
  }

  Future<Map?> queryNominationsCount() async {
    final res = await service.queryNominationsCount();
    return res;
  }

  /// query staking stash-controller relationship of a list of pubKeys,
  /// return list of [pubKey, controllerAddress, stashAddress].
  Future<Map<String?, AccountBondedInfo>> queryBonded(List<String> pubKeys) async {
    if (pubKeys.isEmpty) {
      return {};
    }
    final res = <String?, AccountBondedInfo>{};
    final List data = await (service.queryBonded(pubKeys) as FutureOr<List<dynamic>>);
    for (final e in data) {
      res[e[0]] = AccountBondedInfo(e[0], e[1], e[2]);
    }
    return res;
  }

  Future<OwnStashInfoData> queryOwnStashInfo(String accountId) async {
    final Map data = await (service.queryOwnStashInfo(accountId) as FutureOr<Map<dynamic, dynamic>>);
    return OwnStashInfoData.fromJson(Map<String, dynamic>.of(data as Map<String, dynamic>));
  }

  Future<Map?> loadValidatorRewardsData(String validatorId) async {
    final Map? data = await service.loadValidatorRewardsData(validatorId);
    return data;
  }

  Future<List?> getAccountRewardsEraOptions() async {
    final List? res = await service.getAccountRewardsEraOptions();
    return res;
  }

  // this query takes extremely long time
  Future<Map?> queryAccountRewards(String address, int eras) async {
    final Map? res = await service.fetchAccountRewards(address, eras);
    return res;
  }

  Future<int?> getSlashingSpans(String stashId) async {
    final int? spans = await service.getSlashingSpans(stashId);
    return spans;
  }
}
