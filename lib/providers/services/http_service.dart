import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/constants/http_mock_response.dart';
import 'package:seeds/models/models.dart';

class HttpService {
  String baseURL = Config.defaultEndpoint;
  String userAccount;
  bool mockResponse;

  void update({ String accountName, String nodeEndpoint, bool enableMockResponse = false }) {
    nodeEndpoint = nodeEndpoint;
    userAccount = accountName;
    mockResponse = enableMockResponse;
  }

  static HttpService of(BuildContext context, {bool listen = true}) =>
      Provider.of(context, listen: listen);

  Future<List<String>> getKeyAccounts(String publicKey) async {
    print("[http] get key accounts");

    if (mockResponse == true) {
      return HttpMockResponse.keyAccounts;
    }

    final String keyAccountsURL = "$baseURL/v2/state/get_key_accounts?public_key=$publicKey";

    Response res = await get(keyAccountsURL);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      List<String> keyAccounts = List<String>.from(body["account_names"]);

      print("accounts found");
      print(keyAccounts);

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

      List<MemberModel> members = allAccounts
          .map((item) => MemberModel.fromJson(item))
          .toList();

      return members;
    } else {
      print('Cannot fetch members...');

      return [];
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
          .map((item) => TransactionModel.fromJson(item["act"]["data"]))
          .toList();

      return transactions;
    } else {
      print("Cannot fetch transactions...");

      return [];
    }
  }

  Future<BalanceModel> getBalance() async {
    print("[http] get balance");

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
    print("[http] get voice");

    if (mockResponse == true) {
      return HttpMockResponse.planted;
    }

    final String plantedURL = '$baseURL/v1/chain/get_table_rows';

    String request = '{"json":true,"code":"harvst.seeds","scope":"harvst.seeds","table":"balances","table_key":"","lower_bound":" $userAccount","upper_bound":" $userAccount","index_position":1,"key_type":"i64","limit":100,"reverse":false,"show_payer":false}';
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

  Future<List<ProposalModel>> getProposals(String stage) async {
    print("[http] get proposals: stage = [$stage]");

    if (mockResponse == true) {
      return HttpMockResponse.proposals
          .where((proposal) => proposal.stage == stage)
          .toList();
    }

    final String proposalsURL = '$baseURL/v1/chain/get_table_rows';

    // final String minimumStake = "1.0000 SEEDS";

    String request =
        '{"json":true,"code":"funds.seeds","scope":"funds.seeds","table":"props","table_key":"","lower_bound":"","upper_bound":"","index_position":1,"key_type":"i64","limit":"1000","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(proposalsURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

//      d("body = ${res.body}");

      List<dynamic> activeProposals = body["rows"].where((dynamic item) {
        return item["stage"] == stage; //&& item["staked"] == minimumStake;
      }).toList();

      List<ProposalModel> proposals =
          activeProposals.map((item) => ProposalModel.fromJson(item)).toList();

      return proposals;
    } else {
      print('Cannot fetch proposals...');

      return [];
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
}
