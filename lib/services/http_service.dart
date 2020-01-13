import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'package:seeds/models/models.dart';

class HttpService {
  bool isDebugMode = DotEnv().env['DEBUG_MOCK_HTTP'] != "";

  Future<List<Member>> getMembers() async {
    if (isDebugMode) {
      return [
        Member(
          account: "sevenflash42",
          nickname: "Igor Berlenko",
          image: "",
        ),
      ];
    }

    final String membersURL =
        'https://api.telos.eosindex.io/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":null,"upper_bound":null,"index_position":1,"key_type":"i64","limit":"1000","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(membersURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      List<dynamic> accountsWithProfile = body["rows"].where((dynamic item) {
        return item["image"] != "" &&
            item["nickname"] != "" &&
            item["account"] != "";
      }).toList();

      List<Member> members = accountsWithProfile
          .map((item) => Member.fromJson(item))
          .toList();

      return members;
    } else {
      print('Cannot fetch members...');

      return [];
    }
  }

  Future<List<Transaction>> getTransactions(accountName) async {
    if (isDebugMode) {
      return [
        Transaction(
          "join.seeds",
          "sevenflash42",
          "15.0000 SEEDS",
          ""
        ),
        Transaction(
          "sevenflash42",
          "testingseeds",
          "5.0000 SEEDS",
          ""
        ),
      ];
    }

    final String transactionsURL =
        "https://telos.caleos.io/v2/history/get_actions?account=$accountName&filter=*%3A*&skip=0&limit=100&sort=desc";

    Response res = await get(transactionsURL);

    print('get transactions');

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      List<dynamic> transfers = body["actions"].where((dynamic item) {
        return item["act"]["account"] == "token.seeds" &&
            item["act"]["data"] != null &&
            item["act"]["data"]["from"] != null;
      }).toList();

      List<Transaction> transactions = transfers
          .map((item) => Transaction.fromJson(item["act"]["data"]))
          .toList();

      return transactions;
    } else {
      print("Cannot fetch transactions...");

      return [];
    }
  }

  Future<Balance> getBalance(accountName) async {
    if (isDebugMode) {
      return Balance("10.0000 SEEDS");
    }

    final String balanceURL =
        "https://telos.caleos.io/v1/chain/get_currency_balance";

    String request =
        '{"code":"token.seeds","account":"$accountName","symbol":"SEEDS"}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(balanceURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      Balance balance = Balance.fromJson(body);

      return balance;
    } else {
      print("Cannot fetch balance...");

      return Balance("0.0000 SEEDS");
    }
  }


  Future<Voice> getVoice(accountName) async {
    final String voiceURL =
        'https://api.telos.eosindex.io/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"funds.seeds","scope":"funds.seeds","table":"voice","table_key":"","lower_bound":" $accountName","upper_bound":" $accountName","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(voiceURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      Voice voice = Voice.fromJson(body);

      return voice;
    } else {
      print('Cannot fetch members...');

      return Voice(0);
    }
  }

  Future<List<Proposal>> getProposals(String stage) async {
    final String proposalsURL =
        'https://api.telos.eosindex.io/v1/chain/get_table_rows';

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

      List<Proposal> proposals =
          activeProposals.map((item) => Proposal.fromJson(item)).toList();

      return proposals;
    } else {
      print('Cannot fetch proposals...');

      return [];
    }
  }  
}
