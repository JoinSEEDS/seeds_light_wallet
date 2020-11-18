import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';

class RateNotifier extends ChangeNotifier {
  RateModel rate;
  String _tokenSymbol;

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<RateNotifier>(context, listen: listen);

  void update({HttpService http, String tokenSymbol}) {
    _http = http;
    if (tokenSymbol != _tokenSymbol) fetchRate();
  }

  Future<void> fetchRate() {
    if (_tokenSymbol == "BALI") {
      rate = RateModel(15000, false);
      notifyListeners();
    }

    return _http.getUSDRate().then((result) {
      rate = result;
      notifyListeners();
    });
  }
}
