import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/v2/datasource/remote/model/planted_model.dart';

class PlantedNotifier extends ChangeNotifier {
  PlantedModel balance;

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<PlantedNotifier>(context, listen: listen);

  void update({ HttpService http }) {
    _http = http;
  }

  Future<void> fetchBalance() {
    return _http.getPlanted().then((result) {
      balance = result;
      notifyListeners();
    });
  }
}
