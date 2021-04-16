import 'dart:async';
import 'dart:convert';

import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/constants/http_mock_response.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/voted_notifier.dart';
import 'package:seeds/utils/extensions/response_extension.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/planted_model.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';

class HttpService {
  String? baseURL = remoteConfigurations.defaultEndPointUrl;
  String hyphaURL = remoteConfigurations.hyphaEndPoint;
  String? userAccount;
  bool? mockResponse;

  void update({String? accountName, String? nodeEndpoint, bool enableMockResponse = false}) {
    baseURL = nodeEndpoint;
    userAccount = accountName;
    mockResponse = enableMockResponse;
  }

  static HttpService of(BuildContext context, {bool listen = false}) => Provider.of(context, listen: listen);

  Future<List<dynamic>?> getTableRows({String? code, String? scope, String? table, String? value}) async {
    final requestURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request = value == null
        ? '{"json": true, "code": "$code", "scope": "$scope", "table": "$table"}'
        : '{"json": true, "code": "$code", "scope": "$scope", "table": "$table", "lower_bound": " $value", "upper_bound": " $value", "index_position": 1, "key_type": "i64", "limit": 1, "reverse": false}';

    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(requestURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      final body = res.parseJson() as Map<String, dynamic>;

      return body['rows'] as List<dynamic>?;
    } else {
      print('Cannot fetch table rows... $code $scope $table $value');

      return [];
    }
  }

  Future<UserRecoversModel?> getAccountRecovery(String accountName) async {
    print('[http] get account recovery');

    try {
      if (mockResponse == true) {
        return HttpMockResponse.userRecoversClaimReady;
      }

      var rows =
          await (getTableRows(code: 'guard.seeds', scope: 'guard.seeds', table: 'recovers') as FutureOr<List<dynamic>>);

      final recovery = UserRecoversModel.fromTableRows(rows);

      return recovery;
    } catch (error) {
      print('Error fetching recovers: ${error.toString()}');
      return null;
    }
  }

  Future<UserGuardiansModel?> getAccountGuardians(String accountName) async {
    print('[http] get account guardians');
    try {
      if (mockResponse == true) {
        return HttpMockResponse.userGuardians;
      }

      var rows = await (getTableRows(code: 'guard.seeds', scope: 'guard.seeds', table: 'guards', value: accountName)
          as FutureOr<List<dynamic>>);

      final guardians = UserGuardiansModel.fromTableRows(rows);

      return guardians;
    } catch (error) {
      print('Error fetching account guardians: ${error.toString()}');
      return null;
    }
  }

  Future<ProfileModel> getProfile() async {
    print('[http] get profile');

    if (mockResponse == true) {
      return HttpMockResponse.profile;
    }

    final profileURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":1,"reverse":false,"show_payer":false}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(profileURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      var profile = ProfileModel.fromJson(body['rows'][0]);

      return profile;
    } else {
      print('Cannot fetch profile...');

      return ProfileModel();
    }
  }

  Future<List<Permission>?> getAccountPermissions() async {
    print('[http] get account permissions');

    if (mockResponse == true) {
      return Future.value(HttpMockResponse.accountPermissions);
    }

    final accountPermissionsURL = Uri.parse('$baseURL/v1/chain/get_account');

    var request = '{ "account_name": $userAccount}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(accountPermissionsURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<Permission>? permissions = body['rows'].map((item) => Permission.fromJson(item)).toList();

      return permissions;
    } else {
      print('Cannot fetch account permissions...');
      return <Permission>[];
    }
  }

  Future<List<String?>> getKeyAccountsMongo(String publicKey) async {
    var headers = {'Content-Type': 'application/json'};
    var body = '''
        {
          "collection": "pub_keys",
          "query": {
            "public_key": "$publicKey"\n    
          },
          "limit": 100
        }
        ''';

    var res = await post(Uri.parse('https://mongo-api.hypha.earth/find'), headers: headers, body: body);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      print('result: $body');
      var items = List<Map<String, dynamic>>.from(body['items'])
          .where((item) => item['permission'] == 'active' || item['permission'] == 'owner');
      var result = items.map<String?>((item) => item['account']).toSet().toList();

      result.sort();

      return result;
    } else {
      print('Error fetching accounts: ${res.reasonPhrase}');
      return [];
    }
  }

  Future<List<String>> getKeyAccounts(String publicKey) async {
    print('[http] get key accounts');

    if (mockResponse == true) {
      return HttpMockResponse.keyAccounts;
    }

    final keyAccountsURL = Uri.parse('$baseURL/v2/state/get_key_accounts?public_key=$publicKey');

    var res = await get(keyAccountsURL);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      var keyAccounts = List<String>.from(body['account_names']);

      return keyAccounts;
    } else if (res.statusCode == 400) {
      print('invalid public key');
      return [];
    } else if (res.statusCode == 404) {
      print('no accounts associated with public key');
      return [];
    } else {
      print('unexpected error fetching accounts');
      return [];
    }
  }

  Future<List<MemberModel>> getMembers() async {
    print('[http] get members');

    if (mockResponse == true) {
      return HttpMockResponse.members;
    }

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":null,"upper_bound":null,"index_position":1,"key_type":"i64","limit":"1000","reverse":false,"show_payer":false}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(membersURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<dynamic> allAccounts = body['rows'].toList();

      var members = allAccounts.map((item) => MemberModel.fromJson(item)).toList();

      return members;
    } else {
      print('Cannot fetch members...' + res.body);

      return [];
    }
  }

  Future<List<MemberModel>> getMembersWithFilter(String filter) async {
    print('[http] getMembersWithFilter $filter ');
    if (filter.length < 2) {
      return [];
    }
    var lowerBound = filter;
    var upperBound = filter.padRight(12 - filter.length, 'z');

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":"$lowerBound","upper_bound":"$upperBound","index_position":1,"key_type":"i64","limit":"100","reverse":false,"show_payer":false}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(membersURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<dynamic> allAccounts = body['rows'].toList();

      var members = allAccounts.map((item) => MemberModel.fromJson(item)).toList();

      return members;
    } else {
      print('Cannot fetch members... ${res.body}');

      return [];
    }
  }

  /// V2 is now getMemberByAccountName
  Future<MemberModel?> getMember(String accountName) async {
    print('[http] get member');

    if (mockResponse == true) {
      return HttpMockResponse.members[0];
    }

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":" $accountName","upper_bound":" $accountName","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(membersURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<dynamic> result = body['rows'].toList();

      if (result.length == 1) {
        return MemberModel.fromJson(result[0]);
      } else {
        return null;
      }
    } else {
      print('Cannot fetch members...');

      return null;
    }
  }

  /// In V2 use future.wait on getMemberByAccountName call
  Future<List<MemberModel>> getMembersByIds(List<String?> accountNames) async {
    print('[http] get getMembersByIds ' + accountNames.length.toString());

    if (mockResponse == true) {
      return HttpMockResponse.members;
    }

    final membersURL = Uri.parse('$baseURL/v1/chain/get_table_rows');
    var headers = <String, String>{'Content-type': 'application/json'};

    var requests = accountNames.map((e) =>
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":" $e","upper_bound":" $e","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}');

    var futures = <Future<Response>>[];
    requests.forEach((element) {
      futures.add(post(membersURL, headers: headers, body: element));
    });

    // Waif for all futures to complete
    var res = await Future.wait(futures);
    var filtered = res.where((element) => element.statusCode == 200);

    var users = <MemberModel>[];
    filtered.forEach((element) {
      Map<String, dynamic> body = element.parseJson();

      List<dynamic> result = body['rows'].toList();

      if (result.length == 1) {
        users.add(MemberModel.fromJson(result[0]));
      }
    });

    return users;
  }

  Future<List<TransactionModel>> getTransactions() async {
    print('[http] get transactions');

    if (mockResponse == true) {
      return HttpMockResponse.transactions;
    }

    final transactionsURL =
        Uri.parse('$baseURL/v2/history/get_actions?account=$userAccount&filter=*%3A*&skip=0&limit=100&sort=desc');

    var res = await get(transactionsURL);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<dynamic> transfers = body['actions'].where((dynamic item) {
        return item['act']['account'] == 'token.seeds' &&
            item['act']['data'] != null &&
            item['act']['data']['from'] != null;
      }).toList();

      var transactions = transfers.map((item) => TransactionModel.fromJson(item)).toList();

      return transactions;
    } else {
      print('Cannot fetch transactions...');

      return [];
    }
  }

  Future<List<TransactionModel>> getTransactionsMongo({int blockHeight = 0}) async {
    var url = Uri.parse('https://mongo-api.hypha.earth/find');
    var blockNum = blockHeight;

    var params = '''{ 
      "collection":"action_traces",
      "query": { 
        "act.account": "token.seeds",
        "act.name":"transfer",
        "block_num": {"\$gt": $blockNum },
        "\$or": [ { "act.data.from": "$userAccount" }, { "act.data.to":"$userAccount"} ]
      },
      "projection":{
        "trx_id": true,
        "block_num": true,
        "block_time": true,
        "act.data": true
      },
      "sort":{
        "block_num": -1
      },
      "skip":0,
      "limit": 100,
      "reverse": true
    }''';

    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(url, headers: headers, body: params);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<dynamic> transfers = body['items'];

      var transactions = transfers.map((item) => TransactionModel.fromJsonMongo(item)).toList();

      return transactions;
    } else {
      print('Error fetching transactions...' + res.parseJson().toString());
      return [];
    }
  }

  Future<BalanceModel> getBalance() async {
    print('[http] get seeds balance');

    if (mockResponse == true) {
      return HttpMockResponse.balance;
    }

    final balanceURL = Uri.parse('$baseURL/v1/chain/get_currency_balance');

    var request = '{"code":"token.seeds","account":"$userAccount","symbol":"SEEDS"}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(balanceURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      List<dynamic> body = res.parseJson();

      var balance = BalanceModel.fromJson(body);

      return balance;
    } else {
      print('Cannot fetch balance...');

      return BalanceModel('0.0000 SEEDS');
    }
  }

  Future<RateModel> getUSDRate() async {
    print('[http] get seeds rate USD');

    if (mockResponse == true) {
      return HttpMockResponse.rate;
    }

    final rateURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request = '{"json":true,"code":"tlosto.seeds","scope":"tlosto.seeds","table":"price"}';

    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(rateURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic>? body = res.parseJson();

      return RateModel.fromJson(body);
    } else {
      print('Cannot fetch balance...' + res.body.toString());

      return RateModel(0, true);
    }
  }

  Future<FiatRateModel> getFiatRates() async {
    print('[http] get fiat rates');

    Response res = await get(Uri.parse("https://api-payment.hypha.earth/fiatExchangeRates?api_key=${Config.fxApiKey}"));

    if (res.statusCode == 200) {
      Map<String, dynamic>? body = res.parseJson();
      return FiatRateModel.fromJson(body);
    } else {
      print('Cannot fetch rates...' + res.body.toString());
      return FiatRateModel(null, error: true);
    }
  }

  Future<BalanceModel> getTelosBalance() async {
    print('[http] get telos balance');

    if (mockResponse == true) {
      return HttpMockResponse.telosBalance;
    }

    final balanceURL = Uri.parse('$baseURL/v1/chain/get_currency_balance');

    var request = '{"code":"eosio.token","account":"$userAccount","symbol":"TLOS"}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(balanceURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      List<dynamic>? body = res.parseJson();

      if (body != null && body.isNotEmpty) {
        return BalanceModel.fromJson(body);
      } else {
        return BalanceModel('0.0000 TLOS');
      }
    } else {
      print('Cannot fetch balance...');

      return BalanceModel('0.0000 TLOS');
    }
  }

  Future<bool?> isDHOMember() async {
    print('[http] is DHO member');

    if (mockResponse == true) {
      return true;
    }

    final daoURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    String request = '{"json": true, "code": "trailservice","scope": "$userAccount","table": "voters"}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(daoURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();
      return body["rows"].length > 0;
    } else {
      print('Cannot fetch dho members...${res.reasonPhrase}');

      return false;
    }
  }

  Future<ExchangeModel> getExchangeConfig() async {
    print('[http] get exchange config');

    if (mockResponse == true) {
      return HttpMockResponse.exchangeConfig;
    }

    final exchangeURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"tlosto.seeds","scope":"tlosto.seeds","table":"config","table_key":"","lower_bound":null,"upper_bound":null,"index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(exchangeURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      var exchangeConfig = ExchangeModel.fromJson(body);

      return exchangeConfig;
    } else {
      print('Cannot fetch exchange config...');

      return ExchangeModel();
    }
  }

  Future<VoiceModel> getCampaignVoice() async {
    return getVoice('funds.seeds');
  }

  Future<VoiceModel> getAllianceVoice() async {
    return getVoice('alliance');
  }

  Future<VoiceModel> getVoice(String scope) async {
    print('[http] get voice $scope');

    if (mockResponse == true) {
      return HttpMockResponse.voice;
    }

    final voiceURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"funds.seeds","scope":"$scope","table":"voice","table_key":"","lower_bound":"$userAccount","upper_bound":"$userAccount","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(voiceURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic>? body = res.parseJson();

      var voice = VoiceModel.fromJson(body);

      return voice;
    } else {
      print('Cannot fetch voice...');

      return VoiceModel(0);
    }
  }

  Future<PlantedModel> getPlanted() async {
    print('[http] get planted');

    if (mockResponse == true) {
      return HttpMockResponse.planted;
    }

    final plantedURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"harvst.seeds","scope":"harvst.seeds","table":"balances","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":100,"reverse":false,"show_payer":false}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(plantedURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic>? body = res.parseJson();

      var balance = PlantedModel.fromJson(body);

      return balance;
    } else {
      print('Cannot fetch planted...');

      return const PlantedModel(0);
    }
  }

  Future<HarvestModel> getHarvest() async {
    print('[http] get harvest');

    if (mockResponse == true) {
      return HttpMockResponse.harvest;
    }

    final harvestURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"harvst.seeds","scope":"harvst.seeds","table":"balances","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":1,"reverse":false,"show_payer":false}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(harvestURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      var harvest = HarvestModel.fromJson(body);

      return harvest;
    } else {
      print('Cannot fetch harvest...');

      return HarvestModel();
    }
  }

  Future<ScoreModel> getScore() async {
    print('[http] get score');

    if (mockResponse == true) {
      return HttpMockResponse.score;
    }

    final scoreURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"harvst.seeds","scope":"harvst.seeds","table":"harvest","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(scoreURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      var score = ScoreModel.fromJson(body);

      return score;
    } else {
      print('Cannot fetch harvest...');

      return ScoreModel();
    }
  }

  Future<List<ProposalModel>> getProposals(String stage, String status, bool reverse) async {
    print('[http] get proposals: stage = [$stage]');

    if (mockResponse == true) {
      return HttpMockResponse.proposals.where((proposal) => proposal.stage == stage).toList();
    }

    final proposalsURL = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"funds.seeds","scope":"funds.seeds","table":"props","table_key":"","lower_bound":"","upper_bound":"","index_position":1,"key_type":"i64","limit":"1000","reverse":false,"show_payer":false}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(proposalsURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<dynamic> activeProposals = body['rows'].where((dynamic item) {
        return item['stage'] == stage && item['status'] == status;
      }).toList();

      var proposals = activeProposals.map((item) => ProposalModel.fromJson(item)).toList();

      return reverse ? List<ProposalModel>.from(proposals.reversed) : proposals;
    } else {
      print('Cannot fetch proposals...');

      return [];
    }
  }

  Future<InviteModel> findInvite(String? inviteHash) async {
    print('[http] find invite by hash');

    if (mockResponse == true) {
      return HttpMockResponse.invite;
    }

    var inviteURL =
        'https://node.hypha.earth/v1/chain/get_table_rows'; // todo: Why is this still Hypha when config has changed?

    var request =
        '{"json":true,"code":"join.seeds","scope":"join.seeds","table":"invites","lower_bound":"$inviteHash","upper_bound":"$inviteHash","index_position":2,"key_type":"sha256","limit":1,"reverse":false,"show_payer":false}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(Uri.parse(inviteURL), headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      if (body['rows'].isNotEmpty) {
        return InviteModel.fromJson(body['rows'][0]);
      } else {
        throw EmptyResultException(
          requestUrl: inviteURL,
          requestBody: request,
        );
      }
    } else {
      throw NetworkException(
        requestUrl: inviteURL,
        requestBody: request,
        responseStatusCode: res.statusCode,
        responseBody: res.body.toString(),
      );
    }
  }

  Future<List<InviteModel>?> getInvites() async {
    print('[http] get active invites');

    if (mockResponse == true) {
      return HttpMockResponse.invites;
    }

    var url = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request =
        '{"json":true,"code":"join.seeds","scope":"join.seeds","table":"invites","table_key":"","lower_bound":"$userAccount","upper_bound":"$userAccount","index_position":3,"key_type":"name","limit":"1000","reverse":false,"show_payer":false}';
    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(url, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      if (body['rows'].length > 0) {
        List<InviteModel>? invites = body['rows'].map((item) => InviteModel.fromJson(item)).toList();

        return invites;
      } else {
        return [];
      }
    } else {
      print('Cannot fetch invites...');

      return [];
    }
  }

  /// returns true if the account name doesn't exist
  Future<bool> isAccountNameAvailable(String accountName) async {
    if (mockResponse == true) {
      return true;
    }

    final keyAccountsURL = Uri.parse('$baseURL/v1/chain/get_account');

    var res = await post(
      keyAccountsURL,
      body: '{ "account_name": "$accountName" }',
    );

    if (res.statusCode == 200) {
      return false;
    } else if (res.statusCode == 500) {
      // the account doesn't exist
      return true;
    } else {
      return false;
    }
  }

  Future<VoteResult> getVote({proposalId = int}) async {
    var url = Uri.parse('$baseURL/v1/chain/get_table_rows');

    var request = '''{
      "json": true,
      "code": "funds.seeds",
      "scope": "$proposalId",
      "table": "votes",
      "table_key": "",
      "lower_bound": "$userAccount",
      "upper_bound": "$userAccount",
      "limit": 10,
      "key_type": "",
      "index_position": "",
      "encode_type": "dec",
      "reverse": false,
      "show_payer": false
    }''';

    var headers = <String, String>{'Content-type': 'application/json'};

    var res = await post(url, headers: headers, body: request);
    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);
      if (body['rows'].length > 0) {
        var item = body['rows'][0];
        int? amount = item['favour'] == 1 ? item['amount'] : -item['amount'];
        return VoteResult(amount, true);
      } else {
        return VoteResult(0, false);
      }
    } else {
      print('Cannot fetch votes...${res.toString()}');
      return VoteResult(0, false, error: true);
    }
  }
}

class NetworkException implements Exception {
  final String? requestUrl;
  final String? requestBody;
  final int? responseStatusCode;
  final String? responseBody;

  NetworkException({
    this.requestUrl,
    this.requestBody,
    this.responseStatusCode,
    this.responseBody,
  });

  String get message => 'request failed $requestUrl ($responseStatusCode)';

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

class EmptyResultException implements Exception {
  final String? requestUrl;
  final String? requestBody;

  EmptyResultException({this.requestUrl, this.requestBody});

  String get message => 'empty result at $requestUrl';

  @override
  String toString() {
    return 'EmptyResultException: $message';
  }
}
