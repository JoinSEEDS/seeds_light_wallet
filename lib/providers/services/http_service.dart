import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:teloswallet/constants/config.dart';
import 'package:teloswallet/constants/http_mock_response.dart';
import 'package:teloswallet/models/models.dart';

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

  String get tablesURL => "$baseURL/v1/chain/get_table_rows";
  
  Map<String, String> headers = {"Content-type": "application/json"};

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
        return item["act"]["account"] == "eosio.token" &&
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

  Future<ResourcesModel> getResources() async {
    print("[http] get cpu balance");

    if (mockResponse == true) {
      return HttpMockResponse.resources;
    }

    String request = json.encode({
      "json": true,
      "code": 'eosio',
      "scope": userAccount,
      "table": "userres"
    });

    Response res = await post(tablesURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      if (body != null && body["rows"] != null && body["rows"].isNotEmpty) {
        return ResourcesModel.fromJson(body["rows"][0]);
      } else {
        return ResourcesModel(
          netWeight: "0.0000 TLOS",
          cpuWeight: "0.0000 TLOS",
          ramBytes: 0,
        );
      }
    } else {
      print("Cannot fetch resources...");

      return ResourcesModel(
        netWeight: "0.0000 TLOS",
        cpuWeight: "0.0000 TLOS",
        ramBytes: 0,
      );
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
