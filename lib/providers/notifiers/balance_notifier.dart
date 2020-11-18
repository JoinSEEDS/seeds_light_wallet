import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';

class BalanceNotifier extends ChangeNotifier {
  BalanceModel balance;
  String _tokenSymbol;

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<BalanceNotifier>(context, listen: listen);

  void update({HttpService http, String tokenSymbol}) {
    _http = http;
    print("UPDATE BALANCE");
    if (tokenSymbol != _tokenSymbol) fetchBalance();
  }

  Future<void> fetchBalance() {
    print("FETCH BALANCE");
    return _http.getBalance().then((result) {
      balance = result;
      notifyListeners();
    });
  }
}
