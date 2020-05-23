import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';

class ProfileNotifier extends ChangeNotifier {
  HttpService _http;

  ProfileModel profile;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<ProfileNotifier>(context, listen: listen);

  void update({HttpService http}) {
    _http = http;
  }

  Future<ProfileModel> fetchProfile() {
    return _http.getProfile().then((result) {
      profile = result;
      notifyListeners();
      return result;
    });
  }
}
