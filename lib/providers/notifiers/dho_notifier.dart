

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/services/http_service.dart';

class DhoNotifier extends ChangeNotifier {
  bool? isDhoMember = false;

  HttpService? _http;

  static DhoNotifier of(BuildContext context, {bool listen = false}) =>
      Provider.of<DhoNotifier>(context, listen: listen);

  void update({HttpService? http}) {
    _http = http;
  }

  Future<void> refresh() {
    return _http!.isDHOMember().then((result) {
      isDhoMember = result;
      notifyListeners();
    });
  }
}
