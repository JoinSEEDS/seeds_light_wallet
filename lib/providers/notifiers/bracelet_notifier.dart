import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';

class BraceletNotifier extends ChangeNotifier {
  PlantedModel balance;

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<BraceletNotifier>(context, listen: listen);

  void update({ HttpService http }) {
    _http = http;
  }

  Future<void> fetchBalance() {
    return _http.getPlanted().then((result) {// TODO change to bracelet
      balance = result;
      notifyListeners();
    });
  }
}
