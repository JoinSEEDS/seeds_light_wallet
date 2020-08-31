import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';

class RateNotifier extends ChangeNotifier {
  RateModel rate;

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<RateNotifier>(context, listen: listen);

  void update({HttpService http}) {
    _http = http;
  }

  Future<void> fetchRate() {
    return _http.getUSDRate().then((result) {
      rate = result;
      notifyListeners();
    });
  }
}
