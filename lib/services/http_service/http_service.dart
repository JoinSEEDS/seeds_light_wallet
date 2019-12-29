import 'dart:convert';

import 'package:http/http.dart';
import 'package:seeds/services/auth_service.dart';
import 'package:seeds/services/http_service/invite_model.dart';

class MemberModel {
  final String account;
  final String nickname;
  final String image;

  MemberModel({this.account, this.nickname, this.image});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      account: json["account"],
      nickname: json["nickname"],
      image: json["image"],
    );
  }
}

class TransactionModel {
  final String from;
  final String to;
  final String quantity;
  final String memo;

  TransactionModel(this.from, this.to, this.quantity, this.memo);

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      json["from"],
      json["to"],
      json["quantity"],
      json["memo"],
    );
  }
}

class BalanceModel {
  final String quantity;

  BalanceModel(this.quantity);

  factory BalanceModel.fromJson(List<dynamic> json) {
    return BalanceModel(json[0] as String);
  }
}

class HttpService {
  final AuthService authService = AuthService();

  final String tablesURL =
      'https://api.telos.eosindex.io/v1/chain/get_table_rows';

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


  Future<List<InviteModel>> getInvites() async {
    String inviterAccount = "sow.seeds";// await authService.getAccountName();

    String request =
        '{"json":true,"code":"join.seeds","scope":"join.seeds","table":"invites","table_key":"","lower_bound":"$inviterAccount","upper_bound":"$inviterAccount","index_position":3,"key_type":"name","limit":"100","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(tablesURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);
      print(body);

      List<dynamic> activeInvites = body["rows"].where((dynamic item) {
        return item["inviteSecret"] == "";
      }).toList();

      List<InviteModel> invites = activeInvites
          .map((item) => InviteModel.fromJson(item))
          .toList();

      print("Invites: ");
      print(invites);

      return invites;
    } else {
      print('Cannot fetch invites...');

      return [];
    }
  }  
}
