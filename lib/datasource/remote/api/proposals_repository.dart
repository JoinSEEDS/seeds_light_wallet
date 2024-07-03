import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/crypto/eosdart/eosdart.dart';
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';
import 'package:seeds/datasource/remote/api/eos_repo/seeds_eos_actions.dart';
import 'package:seeds/datasource/remote/api/http_repo/http_repository.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_smart_contract_accounts.dart';
import 'package:seeds/datasource/remote/api/http_repo/seeds_tables.dart';
import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/datasource/remote/model/delegator_model.dart';
import 'package:seeds/datasource/remote/model/moon_phase_model.dart';
import 'package:seeds/datasource/remote/model/proposal_model.dart';
import 'package:seeds/datasource/remote/model/referendum_model.dart';
import 'package:seeds/datasource/remote/model/support_level_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/datasource/remote/model/vote_cycle_model.dart';
import 'package:seeds/datasource/remote/model/vote_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

class ProposalsRepository extends HttpRepository with EosRepository {
  Future<Result<List<MoonPhaseModel>>> getMoonPhases() {
    print('[http] get moon phases');

    final ms = DateTime.now().toUtc().millisecondsSinceEpoch;
    final request = createRequest(
      code: SeedsCode.accountCycle,
      scope: SeedsCode.accountCycle.value,
      table: SeedsTable.tableMoonphases,
      limit: 4,
      lowerBound: '${(ms / 1000).round()}',
    );

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<MoonPhaseModel>>(response, (dynamic body) {
              return body['rows'].map<MoonPhaseModel>((i) => MoonPhaseModel.fromJson(i)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<VoteCycleModel>> getCurrentVoteCycle() {
    print('[http] get vote cycle');

    final request = createRequest(
      code: SeedsCode.accountFunds,
      scope: SeedsCode.accountFunds.value,
      table: SeedsTable.tableCycleStats,
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
      code: SeedsCode.accountFunds,
      scope: SeedsCode.accountFunds.value,
      table: SeedsTable.tableProps,
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

  Future<Result<List<ReferendumModel>>> getReferendums(String scope, bool isReverse) {
    print('[http] get referendums: stage = [$scope]');

    final request = createRequest(
      code: SeedsCode.accountRules,
      scope: scope,
      table: SeedsTable.tableReferendums,
      limit: 100,
      reverse: isReverse,
    );

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<ReferendumModel>>(response, (dynamic body) {
              // The referendums do not have a status field as do the proposals, so the scope must be added
              // to each referendum, which also acts as a status field.
              final List<ReferendumModel> result =
                  body['rows'].map<ReferendumModel>((i) => ReferendumModel.fromJson(i, scope)).toList();
              return result;
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<List<SupportLevelModel>>> getSupportLevel(String scope) {
    print('[http] get support level for scope: $scope');

    final request = createRequest(code: SeedsCode.accountFunds, scope: scope, table: SeedsTable.tableSupport);

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<List<SupportLevelModel>>(response, (dynamic body) {
              return body['rows'].map<SupportLevelModel>((i) => SupportLevelModel.fromJson(i)).toList();
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<VoteModel>> getProposalVote(int proposalId, String account) {
    print('[http] get vote for proposal: $proposalId');

    final request = createRequest(
      code: SeedsCode.accountFunds,
      scope: '$proposalId',
      table: SeedsTable.tableProposalVotes,
      lowerBound: account,
      upperBound: account,
      limit: 10,
    );

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<VoteModel>(response, (dynamic body) {
              return VoteModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<VoteModel>> getReferendumVote(int referendumId, String account) {
    print('[http] get vote for referendum: $referendumId');

    final request = createRequest(
      code: SeedsCode.accountRules,
      scope: '$referendumId',
      table: SeedsTable.tableReferendumVoters,
      lowerBound: account,
      upperBound: account,
      limit: 10,
    );

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(proposalsURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<VoteModel>(response, (dynamic body) {
              return VoteModel.fromJsonReferendum(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<TransactionResponse>> voteProposal(
      {required int id, required int amount, required String accountName}) {
    print('[eos] vote proposal $id ($amount)');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountFunds.value
        ..name = amount.isNegative ? SeedsEosAction.actionNameAgainst.value : SeedsEosAction.actionNameFavour.value
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {'user': accountName, 'id': id, 'amount': amount.abs()}
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<TransactionResponse>> voteReferendum(
      {required int id, required int amount, required String accountName}) {
    print('[eos] vote referendum $id ($amount)');

    final transaction = buildFreeTransaction([
      Action()
        ..account = SeedsCode.accountRules.value
        ..name = amount.isNegative ? SeedsEosAction.actionNameAgainst.value : SeedsEosAction.actionNameFavour.value
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = permissionActive
        ]
        ..data = {'voter': accountName, 'referendum_id': id, 'amount': amount.abs()}
    ], accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  Future<Result<TransactionResponse>> setDelegate({required String accountName, required String delegateTo}) {
    print('[eos] set delegate $accountName -> $delegateTo');

    final List<Action> delegateActions = List.from(
        voiceScopes.map((scope) => _createDelegateAction(delegator: accountName, delegatee: delegateTo, scope: scope)));

    final transaction = buildFreeTransaction(delegateActions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
              return TransactionResponse.fromJson(map);
            }))
        .catchError((error) => mapEosError(error));
  }

  // return DelegateModel
  Future<Result<DelegateModel>> getDelegate(String account, SeedsCode seedsCode) {
    print('[http] get delegate for $account');

    final request = createRequest(
      code: SeedsCode.accountFunds,
      scope: seedsCode.value,
      table: SeedsTable.tableDelegates,
      lowerBound: account,
      upperBound: account,
    );

    final url = Uri.parse('$baseURL/v1/chain/get_table_rows');

    return http
        .post(url, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<DelegateModel>(response, (dynamic body) {
              return DelegateModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result<List<DelegatorModel>>> getDelegators(String account, SeedsCode seedsCode) {
    print('[http] get delegators for $account');

    final request = createRequest(
      code: SeedsCode.accountFunds,
      indexPosition: 2,
      scope: seedsCode.value,
      table: SeedsTable.tableDelegates,
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

  Future<Result<TransactionResponse>> undelegate({required String accountName}) {
    print('[eos] undelegate all delegations for $accountName');

    final List<Action> undelegateActions =
        List.from(voiceScopes.map((scope) => _createUndelegateAction(delegator: accountName, scope: scope)));

    final transaction = buildFreeTransaction(undelegateActions, accountName);

    return buildEosClient()
        .pushTransaction(transaction)
        .then((dynamic response) => mapEosResponse<TransactionResponse>(response, (dynamic map) {
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
        ..account = SeedsCode.accountFunds.value
        ..name = SeedsEosAction.proposalActionNameDelegate.value
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
        ..account = SeedsCode.accountFunds.value
        ..name = SeedsEosAction.proposalActionNameUndelegate.value
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
