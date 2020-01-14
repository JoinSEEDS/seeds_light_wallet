import 'package:seeds/services/http_service/balance_model.dart';
import 'package:seeds/services/http_service/transaction_model.dart';
import 'package:seeds/services/http_service/http_service.dart';

class Repository {

  static final Repository _singleton = Repository._internal();
  
  Repository._internal() {}

  factory Repository() {
    return _singleton;
  }

  final httpService = HttpService();

  Map<String, List<TransactionModel>> _transactions = {};
  BalanceModel _balance;

  Future<List<TransactionModel>> getTransactions(accountName, [reload = false]) async { 
    if (reload || !_transactions.containsKey(accountName)) {
      _transactions[accountName] = await httpService.getTransactions(accountName);
    }
    return _transactions[accountName];
  }

  Future<BalanceModel> getBalance(accountName, [reload = false]) async { 
    if (reload || _balance == null) {
      _balance = await httpService.getBalance(accountName);
    }
    return _balance;
  }
}