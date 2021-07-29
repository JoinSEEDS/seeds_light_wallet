import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart/eosdart.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/v2/datasource/remote/api/eos_repository.dart';
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/moon_phase_model.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/datasource/remote/model/support_level_model.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_response.dart';
import 'package:seeds/v2/datasource/remote/model/vote_model.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

class ProposalsRepository extends NetworkRepository with EosRepository {
  Future<Result> getMoonPhases() async {
    print('[http] get moon phases');

    var ms = DateTime.now().toUtc().millisecondsSinceEpoch;
    var request = createRequest(
      code: account_cycle,
      scope: account_cycle,
      table: table_moonphases,
      limit: 4,
      keyType: '',
      lowerBound: '${(ms / 1000).round()}',
    );

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return body['rows'].map<MoonPhaseModel>((i) => MoonPhaseModel.fromJson(i)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getProposals(ProposalType proposalType) async {
    print('[http] get proposals type - ${proposalType.type}');

    var request = createRequest(
      code: account_funds,
      scope: account_funds,
      table: table_props,
      lowerBound: proposalType.lowerUpperBound,
      upperBound: proposalType.lowerUpperBound,
      limit: 100,
      indexPosition: proposalType.indexPosition,
      reverse: proposalType.isReverse,
    );

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              List<ProposalModel> result = body['rows'].map<ProposalModel>((i) => ProposalModel.fromJson(i)).toList();
              if (proposalType.filterByStage != null) {
                result.retainWhere((e) => e.stage == proposalType.filterByStage);
              } 
              return result;
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getSupportLevels(String scope) async {
    print('[http] get suppor leves for scope: $scope');

    var request = createRequest(code: account_funds, scope: scope, table: table_support, limit: 1);

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return body['rows'].map<SupportLevelModel>((i) => SupportLevelModel.fromJson(i)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getVote(int proposalId, String account) async {
    print('[http] get vote for proposal: $proposalId');

    var request = createRequest(
      code: account_funds,
      scope: '$proposalId',
      table: table_votes,
      lowerBound: account,
      upperBound: account,
      limit: 10,
    );

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return VoteModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> voteProposal({required int id, required int amount, required String accountName}) async {
    print('[eos] vote proposal $id ($amount)');

    var transaction = buildFreeTransaction([
      Action()
        ..account = account_funds
        ..name = amount.isNegative ? action_name_against : action_name_favour
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permission_active
        ]
        ..data = {'user': accountName, 'id': id, 'amount': amount.abs()}
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction, broadcast: true)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }
}
