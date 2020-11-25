import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';

class VoiceNotifier extends ChangeNotifier {
  VoiceModel campaignBalance;
  VoiceModel allianceBalance;

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<VoiceNotifier>(context, listen: listen);

  void update({ HttpService http }) {
    _http = http;
  }

  Future<void> fetchBalance() {
    return Future.wait([_http.getCampaignVoice(), _http.getAllianceVoice()]).then((result) {
      campaignBalance = result[0];
      allianceBalance = result[1];
      notifyListeners();
    });
  }
}
