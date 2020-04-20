import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsNotifier extends ChangeNotifier {

  static const ACCOUNT_NAME = "accountName";
  static const PRIVATE_KEY = "privateKey";
  static const PASSCODE = "passcode";
  static const NODE_ENDPOINT = "nodeEndpoint";

  String _privateKey;
  String _passcode;

  get isInitialized => _preferences != null;
  get accountName => _preferences?.getString(ACCOUNT_NAME);
  get privateKey => _privateKey;
  get passcode => _passcode;
  get nodeEndpoint => _preferences?.getString(NODE_ENDPOINT);

  set nodeEndpoint(String value) => _preferences?.setString(NODE_ENDPOINT, value);

  set accountName(String value) => _preferences?.setString(ACCOUNT_NAME, value);

  set privateKey(String value) {
    _secureStorage.write(key: PRIVATE_KEY, value: value);
    _privateKey = value;
  }

  set passcode(String value) {
    _secureStorage.write(key: PASSCODE, value: value);
    _passcode = value;
  }

  SharedPreferences _preferences;
  FlutterSecureStorage _secureStorage;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<SettingsNotifier>(context, listen: listen);

  void init() async {
    _preferences = await SharedPreferences.getInstance();
    _secureStorage = FlutterSecureStorage();
    _secureStorage.readAll()
      .then((values) {
        _privateKey = values[PRIVATE_KEY];
        if(_privateKey == null) {
          _privateKey = _migrateFromPrefs(PRIVATE_KEY);
        }

        _passcode = values[PASSCODE];
        if(_passcode == null) {
          _passcode = _migrateFromPrefs(PASSCODE);
        }
      })
      .whenComplete(() => notifyListeners());
  }

  // TODO: @Deprecated("Temporary while people still have the previous app version. Remove after 2020-05-31")
  String _migrateFromPrefs(String key) {
    String value = _preferences.get(key);
    if(value != null) {
      _secureStorage.write(key: key, value: value);
      _preferences?.remove(key);
      debugPrint("Converted $key to secure storage");
    }
    return value;
  }

  void update({String nodeEndpoint}) {
    if (nodeEndpoint != _preferences?.getString(NODE_ENDPOINT)) {
      saveEndpoint(nodeEndpoint);
    }
  }

  void savePasscode(String passcode) {
    this.passcode = passcode;
    notifyListeners();
  }

  void saveAccount(String accountName, String privateKey) {
    this.accountName = accountName;
    this.privateKey = privateKey;
    notifyListeners();
  }

  void removeAccount() {
    _preferences?.remove(ACCOUNT_NAME);
    _secureStorage.delete(key: ACCOUNT_NAME);
    _preferences?.remove(PRIVATE_KEY);
    _secureStorage.delete(key: PRIVATE_KEY);
    _privateKey = null;
    _preferences?.remove(PASSCODE);
    _secureStorage.delete(key: PASSCODE);
    _passcode = null;
    notifyListeners();
  }

  void saveEndpoint(String nodeEndpoint) {
    _preferences?.setString(NODE_ENDPOINT, nodeEndpoint);
    notifyListeners();
  }
}
