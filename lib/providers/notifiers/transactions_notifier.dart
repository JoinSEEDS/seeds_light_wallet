import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/utils/extensions/SafeHive.dart';

class TransactionsNotifier extends ChangeNotifier {
  List<TransactionModel> transactions;

  HttpService _http;

  static TransactionsNotifier of(BuildContext context, {bool listen = false}) =>
      Provider.of<TransactionsNotifier>(context, listen: listen);

  void update({HttpService http, AuthNotifier auth}) {
    _http = http;
  }

  Future fetchTransactionsCache() async {
    Box cacheTransactions =
        await SafeHive.safeOpenBox<TransactionModel>('transactions');
    if (cacheTransactions != null && cacheTransactions.isNotEmpty) {
      transactions = cacheTransactions.values.toList();
      notifyListeners();
    }
  }

  Future refreshTransactions() async {
    Box cacheTransactions =
        await SafeHive.safeOpenBox<TransactionModel>('transactions');

    var actualTransactions = await _http.getTransactions();

    if (actualTransactions.isNotEmpty) {
      await cacheTransactions.clear();
      await cacheTransactions.addAll(actualTransactions);
    }

    transactions = cacheTransactions.values.toList();

    notifyListeners();
  }
}
