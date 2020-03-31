import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:teloswallet/models/models.dart';
import 'package:teloswallet/providers/notifiers/auth_notifier.dart';
import 'package:teloswallet/providers/services/http_service.dart';

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
        await Hive.openBox<TransactionModel>("transactions");
    if (cacheTransactions != null && cacheTransactions.isNotEmpty) {
      transactions = cacheTransactions.values.toList();
      notifyListeners();
    }
  }

  Future refreshTransactions() async {
    Box cacheTransactions =
        await Hive.openBox<TransactionModel>("transactions");

    List<TransactionModel> actualTransactions = await _http.getTransactions();

    if (actualTransactions.length > cacheTransactions.values.length) {
      await cacheTransactions.clear();
      await cacheTransactions.addAll(actualTransactions);
    }

    transactions = cacheTransactions.values.toList();

    notifyListeners();
  }
}
