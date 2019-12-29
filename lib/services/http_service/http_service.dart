import 'dart:convert';

import 'package:http/http.dart';
import 'package:seeds/services/http_service/balance_model.dart';
import 'package:seeds/services/http_service/member_model.dart';
import 'package:seeds/services/http_service/proposal_model.dart';
import 'package:seeds/services/http_service/transaction_model.dart';
import 'package:seeds/services/http_service/voice_model.dart';

class HttpService {
  Future<List<MemberModel>> getMembers() async {
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

      List<MemberModel> members = accountsWithProfile
          .map((item) => MemberModel.fromJson(item))
          .toList();

      return members;
    } else {
      print('Cannot fetch members...');

      return [];
    }
  }

  Future<List<TransactionModel>> getTransactions(accountName) async {
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

      List<TransactionModel> transactions = transfers
          .map((item) => TransactionModel.fromJson(item["act"]["data"]))
          .toList();

      return transactions;
    } else {
      print("Cannot fetch transactions...");

      return [];
    }
  }

  Future<BalanceModel> getBalance(accountName) async {
    final String balanceURL =
        "https://telos.caleos.io/v1/chain/get_currency_balance";

    String request =
        '{"code":"token.seeds","account":"$accountName","symbol":"SEEDS"}';
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

  Future<VoiceModel> getVoice(accountName) async {
    final String voiceURL =
        'https://api.telos.eosindex.io/v1/chain/get_table_rows';

    String request =
        '{"json":true,"code":"funds.seeds","scope":"funds.seeds","table":"voice","table_key":"","lower_bound":" $accountName","upper_bound":" $accountName","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
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

  Future<List<ProposalModel>> getProposals() async {
    final String proposalsURL =
        'https://api.telos.eosindex.io/v1/chain/get_table_rows';

    final String minimumStake = "1.0000 SEEDS";

    String request =
        '{"json":true,"code":"funds.seeds","scope":"funds.seeds","table":"props","table_key":"","lower_bound":"","upper_bound":"","index_position":1,"key_type":"i64","limit":"1","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(proposalsURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      List<dynamic> activeProposals = body["rows"].where((dynamic item) {
        return item["status"] == "open" && item["staked"] == minimumStake;
      }).toList();

      List<ProposalModel> proposals = activeProposals
          .map((item) => ProposalModel.fromJson(item))
          .toList();

      return proposals;
    } else {
      print('Cannot fetch proposals...');

      return [];
    }
  }
}
