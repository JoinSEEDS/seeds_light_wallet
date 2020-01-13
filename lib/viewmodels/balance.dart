import 'package:flutter/foundation.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/services/http_service.dart';
import 'package:seeds/viewmodels/auth.dart';

class BalanceModel extends ChangeNotifier {
  Balance balance;

  AuthModel _auth;
  HttpService _http;

  BalanceModel({ auth, http }) : _auth = auth, _http = http;

  void fetchBalance() {
    print("fetch balance");
    _http.getBalance(_auth.accountName).then((result) {
      balance = result;
      notifyListeners();
    });
  }

  void initDependencies({ HttpService http, AuthModel auth }) {
    if (_http == null)
      _http = http;

    if (_auth == null)
      _auth = auth;
  }
}
