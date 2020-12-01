import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';

class RateNotifier extends ChangeNotifier {
  RateModel rate;

  String tokenSymbol;
  String tokenContract;

  HttpService http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<RateNotifier>(context, listen: listen);

  void update({
    HttpService http,
    String tokenSymbol,
    String tokenContract,
  }) {
    this.http = http;
    if (tokenSymbol != this.tokenSymbol || tokenContract != this.tokenContract)
      fetchRate();
  }

  Future<void> fetchRate() {
    return this
        .http
        .getUSDRate(this.tokenContract, this.tokenSymbol)
        .then((result) {
      rate = result;
      notifyListeners();
    });
  }
}
