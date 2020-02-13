import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotifier extends ChangeNotifier {
  get isInitialized => _preferences != null;
  get accountName => _preferences?.getString("accountName");

  get privateKey => _preferences?.getString("privateKey");

  get passcode => _preferences?.getString("passcode");

  get nodeEndpoint => _preferences?.getString("nodeEndpoint");

  set nodeEndpoint(String value) =>
      _preferences?.setString("nodeEndpoint", value);

  set accountName(String value) =>
      _preferences?.setString("accountName", value);

  set privateKey(String value) => _preferences?.setString("privateKey", value);

  set passcode(String value) => _preferences?.setString("passcode", value);

  SharedPreferences _preferences;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<SettingsNotifier>(context, listen: listen);

  void init() async {
    _preferences = await SharedPreferences.getInstance();
    notifyListeners();
  }

  void update({String nodeEndpoint}) {
    if (nodeEndpoint != _preferences?.getString("nodeEndpoint")) {
      saveEndpoint(nodeEndpoint);
    }
  }

  void savePasscode(String passcode) {
    _preferences?.setString("passcode", passcode);
    notifyListeners();
  }

  void saveAccount(String accountName, String privateKey) {
    _preferences?.setString("accountName", accountName);
    _preferences?.setString("privateKey", privateKey);
    notifyListeners();
  }

  void removeAccount() {
    _preferences?.remove("accountName");
    _preferences?.remove("privateKey");
    _preferences?.remove("passcode");
    notifyListeners();
  }

  void saveEndpoint(String nodeEndpoint) {
    _preferences?.setString("nodeEndpoint", nodeEndpoint);
    notifyListeners();
  }
}
