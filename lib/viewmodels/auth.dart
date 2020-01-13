import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  INIT,
  CREATE,
  LOCK,
  UNLOCK,
  OPEN
}

class AuthModel extends ChangeNotifier {
  AuthStatus status = AuthStatus.INIT;
  
  get accountName => _accountName;
  get privateKey => _privateKey;
  get passcode => _passcode;

  String _accountName;
  String _privateKey;
  String _passcode;

  SharedPreferences _prefs;
  bool _locked;

  AuthModel() {
    _init();
  }

  void _init() async {
    _prefs = await SharedPreferences.getInstance();
    
    _locked = true;
    _accountName = _prefs.getString("accountName");
    _privateKey = _prefs.getString("privateKey");
    _passcode = _prefs.getString("passcode");

    updateStatus();
  }

  void updateStatus() {
    status = AuthStatus.OPEN;

    if (_locked == true) {
      status = AuthStatus.UNLOCK;
    }

    if (_passcode.isEmpty) {
      status = AuthStatus.LOCK;
    }

    if (_accountName.isEmpty || _privateKey.isEmpty) {
      status = AuthStatus.CREATE;
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
  }
}