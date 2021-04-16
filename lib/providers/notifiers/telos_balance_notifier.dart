

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';

class TelosBalanceNotifier extends ChangeNotifier {
  BalanceModel? balance;

  HttpService? _http;

  static TelosBalanceNotifier of(BuildContext context, {bool listen = false}) => Provider.of<TelosBalanceNotifier>(context, listen: listen);

  void update({HttpService? http}) {
    _http = http;
  }

  Future<void> fetchBalance() {
    return _http!.getTelosBalance().then((result) {
      balance = result;
      notifyListeners();
    });
  }
}
