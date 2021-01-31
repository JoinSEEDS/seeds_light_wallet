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

class HttpService {
  String baseURL = Config.defaultEndpoint;
  String hyphaURL = Config.hyphaEndpoint;
  String userAccount;
  bool mockResponse;

  void update(
      {String accountName,
      String nodeEndpoint,
      bool enableMockResponse = false}) {
    nodeEndpoint = nodeEndpoint;
    userAccount = accountName;
    mockResponse = enableMockResponse;
  }

  static HttpService of(BuildContext context, {bool listen = false}) =>
      Provider.of(context, listen: listen);

  Future<List<dynamic>> getTableRows(
      {String code, String scope, String table, String value}) async {
    final String requestURL = "$baseURL/v1/chain/get_table_rows";

    String request = value == null
        ? '{"json": true, "code": "$code", "scope": "$scope", "table": "$table"}'
        : '{"json": true, "code": "$code", "scope": "$scope", "table": "$table", "lower_bound": " $value", "upper_bound": " $value", "index_position": 1, "key_type": "i64", "limit": 1, "reverse": false}';

    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(requestURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      final body = res.parseJson() as Map<String, dynamic>;

      return body["rows"] as List<dynamic>;
    } else {
      print('Cannot fetch table rows... $code $scope $table $value');

      return [];
    }
  }

  Future<UserRecoversModel> getAccountRecovery(String accountName) async {
    print("[http] get account recovery");

    try {
      if (mockResponse == true) {
        return HttpMockResponse.userRecoversClaimReady;
      }

      List<dynamic> rows = await getTableRows(
          code: "guard.seeds", scope: "guard.seeds", table: "recovers");

      final recovery = UserRecoversModel.fromTableRows(rows);

      return recovery;
    } catch (error) {
      print("Error fetching recovers: ${error.toString()}");
      return null;
    }
  }

  Future<UserGuardiansModel> getAccountGuardians(String accountName) async {
    print("[http] get account guardians");
    try {
      if (mockResponse == true) {
        return HttpMockResponse.userGuardians;
      }

      List<dynamic> rows = await getTableRows(
          code: "guard.seeds",
          scope: "guard.seeds",
          table: "guards",
          value: accountName);

      final guardians = UserGuardiansModel.fromTableRows(rows);

      return guardians;
    } catch (error) {
      print("Error fetching account guardians: ${error.toString()}");
      return null;
    }
  }

  Future<ProfileModel> getProfile() async {
    print("[http] get profile");

    if (mockResponse == true) {
      return HttpMockResponse.profile;
    }

    final String profileURL = '$baseURL/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":1,"reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(profileURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      ProfileModel profile = ProfileModel.fromJson(body["rows"][0]);

      return profile;
    } else {
      print('Cannot fetch profile...');

      return ProfileModel();
    }
  }

  Future<List<Permission>> getAccountPermissions() async {
    print("[http] get account permissions");

    if (mockResponse == true) {
      return Future.value(HttpMockResponse.accountPermissions);
    }

    final String accountPermissionsURL = "$baseURL/v1/chain/get_account";

    String request = '{ "account_name": $userAccount}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res =
        await post(accountPermissionsURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<Permission> permissions =
          body["rows"].map((item) => Permission.fromJson(item)).toList();

      return permissions;
    } else {
      print('Cannot fetch account permissions...');
      return List<Permission>();
    }
  }

  Future<List<String>> getKeyAccountsMongo(String publicKey) async {
    var headers = {'Content-Type': 'application/json'};
    var body =
        '''
        {
          "collection": "pub_keys",
          "query": {
            "public_key": "$publicKey"\n    
          },
          "limit": 100
        }
        ''';

    Response res = await post(Uri.parse('https://mongo-api.hypha.earth/find'), headers: headers, body: body);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      print("result: $body");
      var items = List<Map<String, dynamic>>.from(body["items"]).where((item) => item["permission"] == "active" || item["permission"] == "owner");
      List<String> result = items
          .map<String>((item) => item["account"])
          .toSet()
          .toList();

      result.sort();

      return result;
    } else {
      print("Error fetching accounts: ${res.reasonPhrase}");
      return [];
    }
  }

  Future<List<String>> getKeyAccounts(String publicKey) async {
    print("[http] get key accounts");

    if (mockResponse == true) {
      return HttpMockResponse.keyAccounts;
    }

    final String keyAccountsURL =
        "$baseURL/v2/state/get_key_accounts?public_key=$publicKey";

    Response res = await get(keyAccountsURL);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<String> keyAccounts = List<String>.from(body["account_names"]);

      return keyAccounts;
    } else if (res.statusCode == 400) {
      print("invalid public key");
      return [];
    } else if (res.statusCode == 404) {
      print("no accounts associated with public key");
      return [];
    } else {
      print("unexpected error fetching accounts");
      return [];
    }
  }

  Future<List<MemberModel>> getMembers() async {
    print("[http] get members");

    if (mockResponse == true) {
      return HttpMockResponse.members;
    }

    final String membersURL = '$baseURL/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":null,"upper_bound":null,"index_position":1,"key_type":"i64","limit":"1000","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(membersURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<dynamic> allAccounts = body["rows"].toList();

      List<MemberModel> members =
          allAccounts.map((item) => MemberModel.fromJson(item)).toList();

      return members;
    } else {
      print('Cannot fetch members...' + res.body);

      return [];
    }
  }

  Future<List<MemberModel>> getMembersWithFilter(String filter) async {
    print("[http] getMembersWithFilter $filter ");
    if (filter.length < 2) {
      return [];
    }
    String lowerBound = filter;
    String upperBound = filter.padRight(12 - filter.length, "z");

    final String membersURL = '$baseURL/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":"$lowerBound","upper_bound":"$upperBound","index_position":1,"key_type":"i64","limit":"100","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(membersURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<dynamic> allAccounts = body["rows"].toList();

      List<MemberModel> members =
          allAccounts.map((item) => MemberModel.fromJson(item)).toList();

      return members;
    } else {
      print("Cannot fetch members... ${res.body}");

      return [];
    }
  }

  Future<MemberModel> getMember(String accountName) async {
    print("[http] get member");

    if (mockResponse == true) {
      return HttpMockResponse.members[0];
    }

    final String membersURL = '$baseURL/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":" $accountName","upper_bound":" $accountName","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(membersURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<dynamic> result = body["rows"].toList();

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

  Future<List<MemberModel>> getMembersByIds(List<String> accountNames) async {
    print("[http] get getMembersByIds " + accountNames.length.toString());

    if (mockResponse == true) {
      return HttpMockResponse.members;
    }

    final String membersURL = '$baseURL/v1/chain/get_table_rows';
    Map<String, String> headers = {"Content-type": "application/json"};

    Iterable<String> requests = accountNames.map((e) =>
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":" $e","upper_bound":" $e","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}');

    var futures = List<Future<Response>>();
    requests.forEach((element) {
      futures.add(post(membersURL, headers: headers, body: element));
    });

    // Waif for all futures to complete
    List<Response> res = await Future.wait(futures);
    Iterable<Response> filtered =
        res.where((element) => element.statusCode == 200);

    List<MemberModel> users = List<MemberModel>();
    filtered.forEach((element) {
      Map<String, dynamic> body = element.parseJson();

      List<dynamic> result = body["rows"].toList();

      if (result.length == 1) {
        users.add(MemberModel.fromJson(result[0]));
      }
    });

    return users;
  }

  Future<List<TransactionModel>> getTransactions() async {
    print("[http] get transactions");

    if (mockResponse == true) {
      return HttpMockResponse.transactions;
    }

    final String transactionsURL =
        "$baseURL/v2/history/get_actions?account=$userAccount&filter=*%3A*&skip=0&limit=100&sort=desc";

    Response res = await get(transactionsURL);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<dynamic> transfers = body["actions"].where((dynamic item) {
        return item["act"]["account"] == "token.seeds" &&
            item["act"]["data"] != null &&
            item["act"]["data"]["from"] != null;
      }).toList();

      List<TransactionModel> transactions =
          transfers.map((item) => TransactionModel.fromJson(item)).toList();

      return transactions;
    } else {
      print("Cannot fetch transactions...");

      return [];
    }
  }

  Future<BalanceModel> getBalance() async {
    print("[http] get seeds balance");

    if (mockResponse == true) {
      return HttpMockResponse.balance;
    }

    final String balanceURL = "$baseURL/v1/chain/get_currency_balance";

    String request =
        '{"code":"token.seeds","account":"$userAccount","symbol":"SEEDS"}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(balanceURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      List<dynamic> body = res.parseJson();

      BalanceModel balance = BalanceModel.fromJson(body);

      return balance;
    } else {
      print("Cannot fetch balance...");

      return BalanceModel("0.0000 SEEDS", true);
    }
  }

  Future<RateModel> getUSDRate() async {
    print("[http] get seeds rate USD");

    if (mockResponse == true) {
      return HttpMockResponse.rate;
    }

    final String rateURL = '$baseURL/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"tlosto.seeds","scope":"tlosto.seeds","table":"price"}';

    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(rateURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      return RateModel.fromJson(body);
    } else {
      print("Cannot fetch balance..." + res.body.toString());

      return RateModel(0, true);
    }
  }

  Future<FiatRateModel> getFiatRates() async {
    print("[http] get fiat rates");

    Response res = await get("https://api.exchangeratesapi.io/latest?base=USD");

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();
      return FiatRateModel.fromJson(body);
    } else {
      print("Cannot fetch rates..." + res.body.toString());
      return FiatRateModel(null, error: true);
    }
  }

  Future<BalanceModel> getTelosBalance() async {
    print("[http] get telos balance");

    if (mockResponse == true) {
      return HttpMockResponse.telosBalance;
    }

    final String balanceURL = "$baseURL/v1/chain/get_currency_balance";

    String request =
        '{"code":"eosio.token","account":"$userAccount","symbol":"TLOS"}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(balanceURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      List<dynamic> body = res.parseJson();

      if (body != null && body.isNotEmpty) {
        return BalanceModel.fromJson(body);
      } else {
        return BalanceModel("0.0000 TLOS", false);
      }
    } else {
      print("Cannot fetch balance...");

      return BalanceModel("0.0000 TLOS", true);
    }
  }

  Future<bool> isDHOMember() async {
    print("[http] is DHO member");

    if (mockResponse == true) {
      return true;
    }

    final String daoURL = "$baseURL/v1/chain/get_table_rows";

    String request =
        '{"json": true, "code": "dao.hypha","scope": "dao.hypha","table": "members","table_key": "","lower_bound": "$userAccount","upper_bound": "$userAccount","limit": 1,}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(daoURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();
      print("result " + body.toString());
      return body["rows"].length > 0;
    } else {
      print("Cannot fetch dho members...");

      return false;
    }
  }

  Future<ExchangeModel> getExchangeConfig() async {
    print("[http] get exchange config");

    if (mockResponse == true) {
      return HttpMockResponse.exchangeConfig;
    }

    final String exchangeURL = '$baseURL/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"tlosto.seeds","scope":"tlosto.seeds","table":"config","table_key":"","lower_bound":null,"upper_bound":null,"index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(exchangeURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      ExchangeModel exchangeConfig = ExchangeModel.fromJson(body);

      return exchangeConfig;
    } else {
      print('Cannot fetch exchange config...');

      return ExchangeModel();
    }
  }

  Future<VoiceModel> getCampaignVoice() async {
    return getVoice("funds.seeds");
  }

  Future<VoiceModel> getAllianceVoice() async {
    return getVoice("alliance");
  }

  Future<VoiceModel> getVoice(String scope) async {
    print("[http] get voice $scope");

    if (mockResponse == true) {
      return HttpMockResponse.voice;
    }

    final String voiceURL = '$baseURL/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"funds.seeds","scope":"$scope","table":"voice","table_key":"","lower_bound":"$userAccount","upper_bound":"$userAccount","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(voiceURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      VoiceModel voice = VoiceModel.fromJson(body);

      return voice;
    } else {
      print('Cannot fetch voice...');

      return VoiceModel(0);
    }
  }

  Future<PlantedModel> getPlanted() async {
    print("[http] get planted");

    if (mockResponse == true) {
      return HttpMockResponse.planted;
    }

    final String plantedURL = '$baseURL/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"harvst.seeds","scope":"harvst.seeds","table":"balances","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":100,"reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(plantedURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      PlantedModel balance = PlantedModel.fromJson(body);

      return balance;
    } else {
      print('Cannot fetch planted...');

      return PlantedModel("0.0000 SEEDS");
    }
  }

  Future<HarvestModel> getHarvest() async {
    print("[http] get harvest");

    if (mockResponse == true) {
      return HttpMockResponse.harvest;
    }

    final String harvestURL = '$baseURL/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"harvst.seeds","scope":"harvst.seeds","table":"balances","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":1,"reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(harvestURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      HarvestModel harvest = HarvestModel.fromJson(body);

      return harvest;
    } else {
      print('Cannot fetch harvest...');

      return HarvestModel();
    }
  }

  Future<ScoreModel> getScore() async {
    print("[http] get score");

    if (mockResponse == true) {
      return HttpMockResponse.score;
    }

    final String scoreURL = '$baseURL/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"harvst.seeds","scope":"harvst.seeds","table":"harvest","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(scoreURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      ScoreModel score = ScoreModel.fromJson(body);

      return score;
    } else {
      print('Cannot fetch harvest...');

      return ScoreModel();
    }
  }

  Future<List<ProposalModel>> getProposals(
      String stage, String status, bool reverse) async {
    print("[http] get proposals: stage = [$stage]");

    if (mockResponse == true) {
      return HttpMockResponse.proposals
          .where((proposal) => proposal.stage == stage)
          .toList();
    }

    final String proposalsURL = '$baseURL/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"funds.seeds","scope":"funds.seeds","table":"props","table_key":"","lower_bound":"","upper_bound":"","index_position":1,"key_type":"i64","limit":"1000","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(proposalsURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      List<dynamic> activeProposals = body["rows"].where((dynamic item) {
        return item["stage"] == stage && item["status"] == status;
      }).toList();

      List<ProposalModel> proposals =
          activeProposals.map((item) => ProposalModel.fromJson(item)).toList();

      return reverse ? List<ProposalModel>.from(proposals.reversed) : proposals;
    } else {
      print('Cannot fetch proposals...');

      return [];
    }
  }

  Future<InviteModel> findInvite(String inviteHash) async {
    print("[http] find invite by hash");

    if (mockResponse == true) {
      return HttpMockResponse.invite;
    }

    String inviteURL =
        "https://node.hypha.earth/v1/chain/get_table_rows"; // todo: Why is this still Hypha when config has changed?

    String request =
        '{"json":true,"code":"join.seeds","scope":"join.seeds","table":"invites","lower_bound":"$inviteHash","upper_bound":"$inviteHash","index_position":2,"key_type":"sha256","limit":1,"reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(inviteURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = res.parseJson();

      if (body["rows"].isNotEmpty) {
        return InviteModel.fromJson(body["rows"][0]);
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

  Future<List<InviteModel>> getInvites() async {
    print("[http] get active invites");

    if (mockResponse == true) {
      return HttpMockResponse.invites;
    }

    String url = "$baseURL/v1/chain/get_table_rows";

    String request =
        '{"json":true,"code":"join.seeds","scope":"join.seeds","table":"invites","table_key":"","lower_bound":"$userAccount","upper_bound":"$userAccount","index_position":3,"key_type":"name","limit":"1000","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(url, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      if (body["rows"].length > 0) {
        List<InviteModel> invites =
            body["rows"].map((item) => InviteModel.fromJson(item)).toList();

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
    if (mockResponse == true) return true;

    final String keyAccountsURL = "$baseURL/v1/chain/get_account";

    Response res = await post(
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

  Future<VoteResult> getVote({proposalId: int}) async {
    String url = "$baseURL/v1/chain/get_table_rows";

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

    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(url, headers: headers, body: request);
    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);
      if (body["rows"].length > 0) {
        var item = body["rows"][0];
        int amount = item["favour"] == 1 ? item["amount"] : -item["amount"];
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
  final String requestUrl;
  final String requestBody;
  final int responseStatusCode;
  final String responseBody;

  NetworkException({
    this.requestUrl,
    this.requestBody,
    this.responseStatusCode,
    this.responseBody,
  });

  String get message => "request failed $requestUrl ($responseStatusCode)";

  @override
  String toString() {
    return "NetworkException: $message";
  }
}

class EmptyResultException implements Exception {
  final String requestUrl;
  final String requestBody;

  EmptyResultException({this.requestUrl, this.requestBody});

  String get message => "empty result at $requestUrl";

  @override
  String toString() {
    return "EmptyResultException: $message";
  }
}
