import 'package:flutter/material.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/services/http_service.dart';
import 'package:seeds/models/models.dart';
import 'package:provider/provider.dart';

class TransactionsNotifier extends ChangeNotifier {
  List<TransactionModel> transactions;

  HttpService _http;
  AuthNotifier _auth;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<TransactionsNotifier>(context, listen: listen);

  void init({ HttpService http, AuthNotifier auth }) {
    if (_http == null)
      _http = http;

    if (_auth == null)
      _auth = auth;
  }

  Future fetchTransactions() async {
    transactions = await _http.getTransactions(_auth.accountName);
    notifyListeners();
  }
}