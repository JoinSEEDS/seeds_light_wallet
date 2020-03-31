import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teloswallet/models/models.dart';
import 'package:teloswallet/providers/services/http_service.dart';

class ResourcesNotifier extends ChangeNotifier {
  ResourcesModel value;

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<ResourcesNotifier>(context, listen: listen);

  void update({HttpService http}) {
    _http = http;
  }

  Future<void> fetchResources() {
    return _http.getResources().then((result) {
      value = result;
      notifyListeners();
    });
  }
}
