import 'package:flutter/material.dart';
import 'package:seeds/services/http_service.dart';

import 'package:seeds/models/models.dart';
import 'package:seeds/viewmodels/auth.dart';

class TransactionsModel extends ChangeNotifier {
  List<Transaction> transactions;

  HttpService _http;
  AuthModel _auth;

  TransactionsModel({ http, auth }) : _http = http, _auth = auth;

  Future fetchTransactions() async {
    print('fetch transactions');
    transactions = await _http.getTransactions(_auth.accountName);
    notifyListeners();
  }

  void initDependencies({ HttpService http, AuthModel auth }) {
    print("transactions init deps");

    if (_http == null)
      _http = http;

    if (_auth == null)
      _auth = auth;
  }
}