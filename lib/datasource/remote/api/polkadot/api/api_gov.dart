import 'dart:async';

import 'package:seeds/datasource/remote/api/polkadot/api/polkawallet_api.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/gov/genExternalLinksParams.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/gov/proposalInfoData.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/gov/referendumInfoData.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/gov/treasuryOverviewData.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/gov/treasuryTipData.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/gov.dart';


class ApiGov {
  ApiGov(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceGov service;

  Future<List?> getDemocracyUnlocks(String address) async {
    final List? res = await service.getDemocracyUnlocks(address);
    return res;
  }

  Future<List?> getExternalLinks(GenExternalLinksParams params) async {
    final List? res = await service.getExternalLinks(params.toJson());
    return res;
  }

  Future<List?> getReferendumVoteConvictions() async {
    final List? res = await service.getReferendumVoteConvictions();
    return res;
  }

  Future<List<ReferendumInfo>> queryReferendums(String address) async {
    final List data = await service.queryReferendums(address);
    if (data.length > 0) {
      return data
          .map((e) => ReferendumInfo.fromJson(Map<String, dynamic>.of(e)))
          .toList();
    }
    return [];
  }

  Future<List<ProposalInfoData>> queryProposals() async {
    final List data =
        await (service.queryProposals() as FutureOr<List<dynamic>>);
    return data
        .map((e) => ProposalInfoData.fromJson(Map<String, dynamic>.of(e)))
        .toList();
  }

  Future<ProposalInfoData?> queryNextExternal() async {
    final Map? data = await service.queryNextExternal();
    return data == null
        ? null
        : ProposalInfoData.fromJson(Map<String, dynamic>.from(data));
  }

  Future<Map?> queryTreasuryProposal(String id) async {
    final Map? data = await service.queryTreasuryProposal(id);
    return data;
  }

  Future<Map?> queryCouncilVotes() async {
    final Map? votes = await service.queryCouncilVotes();
    return votes;
  }

  Future<Map?> queryUserCouncilVote(String address) async {
    final Map? votes = await service.queryUserCouncilVote(address);
    return votes;
  }

  Future<Map?> queryCouncilInfo() async {
    final Map? info = await service.queryCouncilInfo();
    return info;
  }

  Future<List<CouncilMotionData>> queryCouncilMotions() async {
    final List? data = await service.queryCouncilMotions();
    if (data != null) {
      return data
          .map((e) => CouncilMotionData.fromJson(Map<String, dynamic>.of(e)))
          .toList();
    }
    return [];
  }

  Future<TreasuryOverviewData> queryTreasuryOverview() async {
    final Map? data = await service.queryTreasuryOverview();
    if (data != null) {
      return TreasuryOverviewData.fromJson(
          Map<String, dynamic>.of(data as Map<String, dynamic>));
    }
    return TreasuryOverviewData();
  }

  Future<List<TreasuryTipData>> queryTreasuryTips() async {
    final List? data = await service.queryTreasuryTips();
    if (data != null) {
      return data
          .map((e) => TreasuryTipData.fromJson(Map<String, dynamic>.of(e)))
          .toList();
    }
    return [];
  }

  Future<List?> getDemocracyLocks(String address) async {
    final List? res = await service.queryDemocracyLocks(address);
    return res;
  }
}
