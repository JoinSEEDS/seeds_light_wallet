import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

enum AuthStatus {
  initial,
  emptyAccount,
  emptyPasscode,
  locked,
  unlocked,
}

class AuthNotifier extends ChangeNotifier {
  AuthStatus status = AuthStatus.initial;
  
  get accountName => _accountName;
  get privateKey => _privateKey;
  get passcode => _passcode;

  String _accountName;
  String _privateKey;
  String _passcode;

  SharedPreferences _prefs;
  bool _locked = true;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<AuthNotifier>(context, listen: listen);

  void init() async {
    _prefs = await SharedPreferences.getInstance();
    
    _locked = true;
    _accountName = _prefs.getString("accountName");
    _privateKey = _prefs.getString("privateKey");
    _passcode = _prefs.getString("passcode");

    updateStatus();
  }

  void updateStatus() {
    status = AuthStatus.unlocked;

    if (_locked == true) {
      status = AuthStatus.locked;
    }

    if (_passcode == null) {
      status = AuthStatus.emptyPasscode;
    }

    if (_accountName == null || _privateKey == null) {
      status = AuthStatus.emptyAccount;
    }

    notifyListeners();
  }

  void unlockWallet() {
    _locked = false;

    updateStatus();
  }

  void savePasscode(String passcode) {
    _passcode = passcode;
    _locked = false;
    _prefs.setString("passcode", passcode);

    updateStatus();
  }

  void saveAccount(String accountName, String privateKey) {
    _prefs.setString("accountName", accountName);
    _prefs.setString("privateKey", privateKey);

    _accountName = accountName;
    _privateKey = privateKey;

    updateStatus();
  }

  void removeAccount() {
    _prefs.remove("accountName");
    _prefs.remove("privateKey");
    _prefs.remove("passcode");

    _accountName = null;
    _privateKey = null;
    _passcode = null;

    updateStatus();
  }
}