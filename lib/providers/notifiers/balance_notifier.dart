import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';

class BalanceNotifier extends ChangeNotifier {
  BalanceModel balance;

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<BalanceNotifier>(context, listen: listen);

  void update({HttpService http}) {
    _http = http;
  }

  void fetchBalance() {
    _http.getBalance().then((result) {
      balance = result;
      notifyListeners();
    });
  }
}
