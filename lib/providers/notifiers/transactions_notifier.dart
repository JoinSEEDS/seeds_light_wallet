import 'package:flutter/material.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/models/models.dart';
import 'package:provider/provider.dart';

class TransactionsNotifier extends ChangeNotifier {
  List<TransactionModel> transactions;

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<TransactionsNotifier>(context, listen: listen);

  void init({ HttpService http, AuthNotifier auth }) {
    if (_http == null)
      _http = http;
  }

  Future fetchTransactions() async {
    transactions = await _http.getTransactions();
    notifyListeners();
  }
}