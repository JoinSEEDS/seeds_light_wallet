import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/constants/http_mock_response.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/utils/invites.dart';

class HttpService {
  String baseURL = Config.defaultEndpoint;
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
      Map<String, dynamic> body = jsonDecode(res.body);

      ProfileModel profile = ProfileModel.fromJson(body["rows"][0]);

      return profile;
    } else {
      print('Cannot fetch profile...');

      return ProfileModel();
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
      Map<String, dynamic> body = jsonDecode(res.body);

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
      Map<String, dynamic> body = jsonDecode(res.body);

      List<dynamic> allAccounts = body["rows"].toList();

      List<MemberModel> members =
          allAccounts.map((item) => MemberModel.fromJson(item)).toList();

      return members;
    } else {
      print('Cannot fetch members...');

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
      Map<String, dynamic> body = jsonDecode(res.body);

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

  Future<List<TransactionModel>> getTransactions() async {
    print("[http] get transactions");

    if (mockResponse == true) {
      return HttpMockResponse.transactions;
    }

    final String transactionsURL =
        "$baseURL/v2/history/get_actions?account=$userAccount&filter=*%3A*&skip=0&limit=100&sort=desc";

    Response res = await get(transactionsURL);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      List<dynamic> transfers = body["actions"].where((dynamic item) {
        return item["act"]["account"] == "token.seeds" &&
            item["act"]["data"] != null &&
            item["act"]["data"]["from"] != null;
      }).toList();

      List<TransactionModel> transactions = transfers
          .map((item) => TransactionModel.fromJson(item))
          .toList();

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
      List<dynamic> body = jsonDecode(res.body);

      BalanceModel balance = BalanceModel.fromJson(body);

      return balance;
    } else {
      print("Cannot fetch balance...");

      return BalanceModel("0.0000 SEEDS");
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
      List<dynamic> body = jsonDecode(res.body);

      if (body != null && body.isNotEmpty) {
        return BalanceModel.fromJson(body);
      } else {
        return BalanceModel("0.0000 TLOS");
      }
    } else {
      print("Cannot fetch balance...");

      return BalanceModel("0.0000 TLOS");
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
      Map<String, dynamic> body = jsonDecode(res.body);

      ExchangeModel exchangeConfig = ExchangeModel.fromJson(body);

      return exchangeConfig;
    } else {
      print('Cannot fetch members...');

      return ExchangeModel();
    }
  }

  Future<VoiceModel> getVoice() async {
    print("[http] get voice");

    if (mockResponse == true) {
      return HttpMockResponse.voice;
    }

    final String voiceURL = '$baseURL/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"funds.seeds","scope":"funds.seeds","table":"voice","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(voiceURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      VoiceModel voice = VoiceModel.fromJson(body);

      return voice;
    } else {
      print('Cannot fetch members...');

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
      Map<String, dynamic> body = jsonDecode(res.body);

      PlantedModel balance = PlantedModel.fromJson(body);

      return balance;
    } else {
      print('Cannot fetch members...');

      return PlantedModel("0.0000 SEEDS");
    }
  }

  Future<HarvestModel> getHarvest() async {
    print("[http] get harvest");

    if (mockResponse == true) {
      return HttpMockResponse.harvest;
    }

    final String harvestURL = '$baseURL/v1/chain/get_table_rows';

    String request = '{"json":true,"code":"harvst.seeds","scope":"harvst.seeds","table":"balances","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":1,"reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(harvestURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

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

    String request = '{"json":true,"code":"harvst.seeds","scope":"harvst.seeds","table":"harvest","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(scoreURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      ScoreModel score = ScoreModel.fromJson(body);

      return score;
    } else {
      print('Cannot fetch harvest...');

      return ScoreModel();
    }
  }

  Future<List<ProposalModel>> getProposals(String stage) async {
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
      Map<String, dynamic> body = jsonDecode(res.body);

      List<dynamic> activeProposals = body["rows"].where((dynamic item) {
        return item["stage"] == stage;
      }).toList();

      List<ProposalModel> proposals =
          activeProposals.map((item) => ProposalModel.fromJson(item)).toList();

      return proposals;
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

    String reversedHash = reverseHash(inviteHash);

    String inviteURL = "https://node.hypha.earth/v1/chain/get_table_rows"; // todo: Why is this still Hypha when config has changed?

    String request =
        '{"json":true,"code":"join.seeds","scope":"join.seeds","table":"invites","lower_bound":"$reversedHash","upper_bound":"$reversedHash","index_position":2,"key_type":"sha256","limit":1,"reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(inviteURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

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

    String invitesURL = "$baseURL/v1/chain/get_table_rows";

    String request =
        '{"json":true,"code":"funds.seeds","scope":"join.seeds","table":"invites","table_key":"","lower_bound":"$userAccount","upper_bound":"$userAccount","index_position":3,"key_type":"name","limit":"1000","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(invitesURL, headers: headers, body: request);

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
  Future<bool> checkAccountName(String accountName) async {
    if (mockResponse == true) return true;

    final String keyAccountsURL =
        "$baseURL/v2/history/get_creator?account=$accountName";

    Response res = await get(keyAccountsURL);

    if (res.statusCode == 200) {
      return false;
    } else if (res.statusCode == 404) {
      // the account doesn't exist
      return true;
    } else {
      return false;
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
