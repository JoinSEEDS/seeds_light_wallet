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
  String tokenSymbol;
  String tokenContract;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<TransactionsNotifier>(context, listen: listen);

  void update(
      {String tokenSymbol,
      String tokenContract,
      HttpService http,
      AuthNotifier auth}) {
    _http = http;
    if (this.tokenSymbol != tokenSymbol ||
        this.tokenContract != tokenContract) {
      this.tokenSymbol = tokenSymbol;
      this.tokenContract = tokenContract;
      fetchTransactionsCache();
      refreshTransactions();
    }
  }

  Future fetchTransactionsCache() async {
    Box cacheTransactions = await SafeHive.safeOpenBox<TransactionModel>(
        "transactions.${this.tokenSymbol}");
    if (cacheTransactions != null && cacheTransactions.isNotEmpty) {
      transactions = cacheTransactions.values.toList();
      notifyListeners();
    }
  }

  Future refreshTransactions() async {
    Box cacheTransactions = await SafeHive.safeOpenBox<TransactionModel>(
        "transactions.${this.tokenSymbol}");

    List<TransactionModel> actualTransactions =
        await _http.getTransactions(this.tokenContract, this.tokenSymbol);

    if (actualTransactions.length > 0) {
      await cacheTransactions.clear();
      await cacheTransactions.addAll(actualTransactions);
    }

    transactions = cacheTransactions.values.toList();

    notifyListeners();
  }
}
