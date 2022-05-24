import 'dart:async';

import 'package:seeds/datasource/remote/api/polkadot/api/polkawallet_api.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/parachain/auctionData.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/parachain/parasOverviewData.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/parachain.dart';

class ApiParachain {
  ApiParachain(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceParachain service;

  Future<ParasOverviewData> queryParasOverview() async {
    final res = await service.queryParasOverview();
    return ParasOverviewData.fromJson(res ?? {});
  }

  Future<AuctionData> queryAuctionWithWinners() async {
    final res = await service.queryAuctionWithWinners();
    return AuctionData.fromJson(res!);
  }

  Future<List<String>> queryUserContributions(List<String> paraIds, String pubKey) async {
    return service.queryUserContributions(paraIds, pubKey);
  }
}
