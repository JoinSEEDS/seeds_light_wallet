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

  void update({ HttpService http, AuthNotifier auth }) {
    _http = http;
  }

  Future fetchTransactions() async {
    transactions = await _http.getTransactions();
    notifyListeners();
  }
}