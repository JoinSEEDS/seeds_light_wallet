import 'package:flutter/foundation.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/services/auth_service.dart';
import 'package:seeds/services/http_service.dart';

class BalanceModel extends ChangeNotifier {
  Balance balance;

  AuthService _auth;
  HttpService _http;

  BalanceModel({ auth, http }) : _auth = auth, _http = http;

  void fetchBalance() {
    print("fetch balance");
    _http.getBalance(_auth.accountName).then((result) {
      print("fetch balance - done");
      print(result);
      balance = result;
    });
  }
}
