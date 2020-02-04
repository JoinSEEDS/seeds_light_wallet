import 'package:flutter/material.dart';
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

  String _accountName;
  String _privateKey;
  String _passcode;
  bool _locked = true;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<AuthNotifier>(context, listen: listen);

  void update({accountName, privateKey, passcode}) async {
    print("update auth notifier: $accountName - $passcode");
    if (accountName != _accountName ||
        privateKey != _privateKey ||
        passcode != passcode) {
      _locked = true;
    }
    _accountName = accountName;
    _privateKey = privateKey;
    _passcode = passcode;

    updateStatus();
  }

  void updateStatus() {
    print("update status");

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

  void lockWallet() {
    _locked = true;
    updateStatus();
  }

  void unlockWallet() {
    _locked = false;
    updateStatus();
  }

  void resetPasscode() {
    _passcode = null;
    updateStatus();
  }
}
