import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

  Future fetchTransactionsCache() async {
    Box cacheTransactions =
        await Hive.openBox<TransactionModel>("transactions3");
    if (cacheTransactions != null && cacheTransactions.isNotEmpty) {
      transactions = cacheTransactions.values.toList();
      notifyListeners();
    }
  }

  Future refreshTransactions() async {
    Box<TransactionModel> cacheTransactions =
        await Hive.openBox<TransactionModel>("transactions3");

    int blockHeight = cacheTransactions.length > 0 ? cacheTransactions.getAt(0).blockNum : 0;

    List<TransactionModel> transactions = await _http.getTransactionsMongo(blockHeight: blockHeight);

    if (transactions.length > 0) {
      var newList = transactions + cacheTransactions.values.toList();
      await cacheTransactions.clear();
      await cacheTransactions.addAll(newList);
    }

    transactions = cacheTransactions.values.toList();

    notifyListeners();
  }
}
