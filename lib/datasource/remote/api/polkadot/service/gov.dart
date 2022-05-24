import 'dart:async';
import 'dart:convert';

import 'package:seeds/datasource/remote/api/polkadot/service/substrate_service.dart';

class ServiceGov {
  ServiceGov(this.serviceRoot);

  final SubstrateService serviceRoot;

  Future<List?> getDemocracyUnlocks(String address) async {
    final dynamic res = await serviceRoot.webView!.evalJavascript('gov.getDemocracyUnlocks(api, "$address")');
    return res;
  }

  Future<List?> getExternalLinks(Map params) async {
    final dynamic res = await serviceRoot.webView!.evalJavascript('settings.genLinks(api, ${jsonEncode(params)})');
    return res;
  }

  Future<List?> getReferendumVoteConvictions() async {
    final dynamic res = await serviceRoot.webView!.evalJavascript('gov.getReferendumVoteConvictions(api)');
    return res;
  }

  Future<List> queryReferendums(String address) async {
    final dynamic data = await serviceRoot.webView!.evalJavascript('gov.fetchReferendums(api, "$address")');
    if (data != null) {
      final List list = data['referendums'];
      list.asMap().forEach((k, v) {
        v['detail'] = data['details'][k];
      });
      return list;
    }
    return [];
  }

  Future<List?> queryProposals() async {
    final dynamic data = await serviceRoot.webView!.evalJavascript('gov.fetchProposals(api)');
    return data;
  }

  Future<Map?> queryNextExternal() async {
    final data = await serviceRoot.webView!.evalJavascript('gov.fetchExternal(api)');
    return data;
  }

  Future<Map?> queryTreasuryProposal(String id) async {
    final dynamic data = await serviceRoot.webView!.evalJavascript('api.query.treasury.proposals($id)');
    return data;
  }

  Future<Map?> queryCouncilVotes() async {
    final dynamic votes = await serviceRoot.webView!.evalJavascript('gov.fetchCouncilVotes(api)');
    return votes;
  }

  Future<Map?> queryUserCouncilVote(String address) async {
    final dynamic votes = await serviceRoot.webView!.evalJavascript('api.derive.council.votesOf("$address")');
    return votes;
  }

  Future<Map?> queryCouncilInfo() async {
    final dynamic info = await serviceRoot.webView!.evalJavascript('api.derive.elections.info()');
    return info;
  }

  Future<List?> queryCouncilMotions() async {
    final dynamic data = await serviceRoot.webView!.evalJavascript('gov.getCouncilMotions(api)');
    return data;
  }

  Future<Map?> queryTreasuryOverview() async {
    final dynamic data = await serviceRoot.webView!.evalJavascript('gov.getTreasuryOverview(api)');
    return data;
  }

  Future<List?> queryTreasuryTips() async {
    final dynamic data = await serviceRoot.webView!.evalJavascript('gov.getTreasuryTips(api)');
    return data;
  }

  Future<List?> queryDemocracyLocks(String address) async {
    final dynamic data = await serviceRoot.webView!.evalJavascript('api.derive.democracy.locks("$address")');
    return data;
  }
}
