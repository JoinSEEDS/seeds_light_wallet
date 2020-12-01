import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';

class TokensNotifier extends ChangeNotifier {
  HttpService _http;

  List<TokenModel> tokens = [];

  String tokenSymbol;
  String tokenContract;

  TokensNotifier({this.tokenSymbol, this.tokenContract});

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<TokensNotifier>(context, listen: false);

  void update({HttpService http, String tokenSymbol, String tokenContract}) {
    _http = http;
    if (this.tokenContract != tokenContract ||
        this.tokenSymbol != tokenSymbol) {
      this.tokenSymbol = tokenSymbol;
      this.tokenContract = tokenContract;
      notifyListeners();
    }
  }

  void fetchTokens() {
    _http.getUserTokens().then((result) {
      tokens = result;
      notifyListeners();
    });
  }
}
