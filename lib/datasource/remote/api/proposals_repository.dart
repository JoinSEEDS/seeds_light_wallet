import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart/eosdart.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/eos_repository.dart';
import 'package:seeds/datasource/remote/api/network_repository.dart';
import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/datasource/remote/model/delegator_model.dart';
import 'package:seeds/datasource/remote/model/moon_phase_model.dart';
import 'package:seeds/datasource/remote/model/proposal_model.dart';
import 'package:seeds/datasource/remote/model/referendum_model.dart';
import 'package:seeds/datasource/remote/model/support_level_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/datasource/remote/model/vote_cycle_model.dart';
import 'package:seeds/datasource/remote/model/vote_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

class ProposalsRepository extends NetworkRepository with EosRepository {
  Future<Result> getMoonPhases() {
    print('[http] get moon phases');

    final ms = DateTime.now().toUtc().millisecondsSinceEpoch;
    final request = createRequest(
      code: accountCycle,
      scope: accountCycle,
      table: tableMoonphases,
      limit: 4,
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

  Future<Result<VoteCycleModel>> getCurrentVoteCycle() {
    print('[http] get vote cycle');

    final request = createRequest(
      code: accountFunds,
      scope: accountFunds,
      table: tableCycleStats,
      // ignore: avoid_redundant_argument_values
      limit: 1,
      reverse: true,
    );

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<VoteCycleModel>(response, (dynamic body) {
              return VoteCycleModel.fromJson(body['rows'][0]);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getProposals(ProposalType proposalType) {
    print('[http] get proposals type - ${proposalType.type}');

    final request = createRequest(
      code: accountFunds,
      scope: accountFunds,
      table: tableProps,
      lowerBound: proposalType.proposalStage,
      upperBound: proposalType.proposalStage,
      limit: 100,
      indexPosition: proposalType.indexPosition,
      reverse: proposalType.isReverse,
    );

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              final List<ProposalModel> result =
                  body['rows'].map<ProposalModel>((i) => ProposalModel.fromJson(i)).toList();
              if (proposalType.filterByStage != null) {
                result.retainWhere((e) => e.stage == proposalType.filterByStage);
              }
              return result;
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getReferendums(String scope, bool isReverse) {
    print('[http] get referendums: stage = [$scope]');

    final request = createRequest(
      code: accountRules,
      scope: scope,
      table: tableReferendums,
      limit: 100,
      reverse: isReverse,
    );

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              // The referendums do not have a status field as do the proposals, so the scope must be added
              // to each referendum, which also acts as a status field.
              final List<ReferendumModel> result =
                  body['rows'].map<ReferendumModel>((i) => ReferendumModel.fromJson(i, scope)).toList();
              return result;
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getSupportLevel(String scope) {
    print('[http] get support level for scope: $scope');

    final request = createRequest(code: accountFunds, scope: scope, table: tableSupport);

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return body['rows'].map<SupportLevelModel>((i) => SupportLevelModel.fromJson(i)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getProposalVote(int proposalId, String account) {
    print('[http] get vote for proposal: $proposalId');

    final request = createRequest(
      code: accountFunds,
      scope: '$proposalId',
      table: tableProposalVotes,
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

  Future<Result> getReferendumVote(int referendumId, String account) {
    print('[http] get vote for referendum: $referendumId');

    final request = createRequest(
      code: accountRules,
      scope: '$referendumId',
      table: tableReferendumVoters,
      lowerBound: account,
      upperBound: account,
      limit: 10,
    );

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return VoteModel.fromJsonReferendum(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> voteProposal({required int id, required int amount, required String accountName}) {
    print('[eos] vote proposal $id ($amount)');

    final transaction = buildFreeTransaction([
      Action()
        ..account = accountFunds
        ..name = amount.isNegative ? actionNameAgainst : actionNameFavour
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {'user': accountName, 'id': id, 'amount': amount.abs()}
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result> voteReferendum({required int id, required int amount, required String accountName}) {
    print('[eos] vote referendum $id ($amount)');

    final transaction = buildFreeTransaction([
      Action()
        ..account = accountRules
        ..name = amount.isNegative ? actionNameAgainst : actionNameFavour
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {'voter': accountName, 'referendum_id': id, 'amount': amount.abs()}
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result> setDelegate({required String accountName, required String delegateTo}) {
    print('[eos] set delegate $accountName -> $delegateTo');

    final List<Action> delegateActions = List.from(
        voiceScopes.map((scope) => _createDelegateAction(delegator: accountName, delegatee: delegateTo, scope: scope)));

    final transaction = buildFreeTransaction(delegateActions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  // return DelegateModel
  Future<Result> getDelegate(String account, String voiceScope) {
    print('[http] get delegate for $account');

    final request = createRequest(
      code: accountFunds,
      scope: voiceScope,
      table: tableDelegates,
      lowerBound: account,
      upperBound: account,
    );

    final url = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(url, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return DelegateModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<List<DelegatorModel>>> getDelegators(String account, String voiceScope) {
    print('[http] get delegators for $account');

    final request = createRequest(
      code: accountFunds,
      indexPosition: 2,
      scope: voiceScope,
      table: tableDelegates,
      lowerBound: account,
      upperBound: account,
      limit: 100,
    );

    final url = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(url, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<DelegatorModel>>(response, (dynamic body) {
              final List<dynamic> allDelegator = body['rows'].toList();
              return allDelegator.map((item) => DelegatorModel.fromJson(item)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> undelegate({required String accountName}) {
    print('[eos] undelegate all delegations for $accountName');

    final List<Action> undelegateActions =
        List.from(voiceScopes.map((scope) => _createUndelegateAction(delegator: accountName, scope: scope)));

    final transaction = buildFreeTransaction(undelegateActions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Action _createDelegateAction({
    required String delegator,
    required String delegatee,
    required String scope,
  }) =>
      Action()
        ..account = accountFunds
        ..name = proposalActionNameDelegate
        ..authorization = [
          Authorization()
            ..actor = delegator
            ..permission = permissionActive
        ]
        ..data = {
          'delegator': delegator,
          'delegatee': delegatee,
          'scope': scope,
        };

  Action _createUndelegateAction({
    required String delegator,
    required String scope,
  }) =>
      Action()
        ..account = accountFunds
        ..name = proposalActionNameUndelegate
        ..authorization = [
          Authorization()
            ..actor = delegator
            ..permission = permissionActive
        ]
        ..data = {
          'delegator': delegator,
          'scope': scope,
        };
}
