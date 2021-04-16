

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';

class ProfileNotifier extends ChangeNotifier {
  HttpService? _http;

  ProfileModel? profile;

  static ProfileNotifier of(BuildContext context, {bool listen = false}) => Provider.of<ProfileNotifier>(context, listen: listen);

  void update({HttpService? http}) {
    _http = http;
  }

  Future<ProfileModel> fetchProfile() {
    return _http!.getProfile().then((result) {
      profile = result;
      notifyListeners();
      return result;
    });
  }
}
