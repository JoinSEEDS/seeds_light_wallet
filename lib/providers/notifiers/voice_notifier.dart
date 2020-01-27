import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';

class VoiceNotifier extends ChangeNotifier {
  VoiceModel balance;

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<VoiceNotifier>(context, listen: listen);

  void update({ HttpService http }) {
    _http = http;
  }

  void fetchBalance() {
    _http.getVoice().then((result) {
      balance = result;
      notifyListeners();
    });
  }
}
