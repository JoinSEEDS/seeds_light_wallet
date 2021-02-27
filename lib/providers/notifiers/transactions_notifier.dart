import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/services/http_service.dart';

class TransactionsNotifier extends ChangeNotifier {
  List<TransactionModel> transactions;

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<TransactionsNotifier>(context, listen: listen);

  void update({HttpService http, AuthNotifier auth}) {
    _http = http;
  }

  List<TransactionModel> transactionsCache = [];

  Future refreshTransactions() async {

    int block = 0;
    if (transactionsCache.length > 0) {
      block = transactionsCache[0].blockNumber;
    }

    List<TransactionModel> newTransactions = await _http.getTransactionsMongo(blockHeight: block);

    transactions = newTransactions + transactionsCache;

    if (transactions.length > 300) {
      transactions.sublist(0, 300);
    }

    transactionsCache = transactions;

    notifyListeners();
  }

  void logout() {
    transactionsCache = [];
  }

}
