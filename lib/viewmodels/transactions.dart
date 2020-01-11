import 'package:flutter/material.dart';
import 'package:seeds/services/auth_service.dart';
import 'package:seeds/services/http_service.dart';

import 'package:seeds/models/models.dart';

class TransactionsModel extends ChangeNotifier {
  List<Transaction> transactions;

  HttpService _http;
  AuthService _auth;

  TransactionsModel({ HttpService http, AuthService auth }) : _http = http, _auth = auth;

  Future fetchTransactions() async {
    print('fetch transactions');
    transactions = await _http.getTransactions(await _auth.getAccountName());
    notifyListeners();
  }

  void update(AuthService auth, HttpService http) {
    if (_http == null)
      _http = http;

    if (_auth == null)
      _auth = auth;
  }
}