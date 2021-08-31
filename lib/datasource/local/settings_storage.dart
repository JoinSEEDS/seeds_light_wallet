import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:seeds/datasource/remote/firebase/firebase_message_token_repository.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Keys
const String _kAccountName = 'accountName';
const String _kPrivateKey = 'privateKey';
const String _kPasscode = 'passcode';
const String _kPasscodeActive = 'passcode_active';
const String _kBiometricActive = 'biometric_active';
const String _kPrivateKeyBackedUp = 'private_key_backed_up';
const String _kSelectedFiatCurrency = 'selected_fiat_currency';
const String _kSelectedToken = 'selected_token';
const String _kInRecoveryMode = 'in_recovery_mode';
const String _kTokensWhiteList = 'tokens_whitelist';
const String _kIsCitizen = 'is_citizen';
const String _kIsFirstRun = 'is_first_run';

// Defaults
const bool _kPasscodeActiveDefault = true;
const bool _kBiometricActiveDefault = false;
const bool _kIsCitizenDefault = false;

class _SettingsStorage {
  late SharedPreferences _preferences;
  late FlutterSecureStorage _secureStorage;
  String? _privateKey;
  String? _passcode;
  bool? _passcodeActive;
  bool? _biometricActive;
  bool? _privateKeyBackedUp;

  factory _SettingsStorage() => _instance;

  _SettingsStorage._();

  static final _SettingsStorage _instance = _SettingsStorage._();

  String get accountName => _preferences.getString(_kAccountName) ?? '';

  String? get privateKey => _privateKey;

  String? get passcode => _passcode;

  bool? get passcodeActive => _passcodeActive;

  bool? get biometricActive => _biometricActive;

  bool get privateKeyBackedUp => _privateKeyBackedUp ?? false;

  String get selectedFiatCurrency => _preferences.getString(_kSelectedFiatCurrency) ?? getPlatformCurrency();

  //TokenModel get selectedToken => TokenModel.fromSymbol(_preferences.getString(_kSelectedToken) ?? SeedsToken.symbol);
  // TODO(n13): Hard coded for now
  TokenModel get selectedToken => TokenModel.fromSymbol(SeedsToken.symbol);

  bool get inRecoveryMode => _preferences.getBool(_kInRecoveryMode) ?? false;

  List<String> get tokensWhitelist => _preferences.getStringList(_kTokensWhiteList) ?? [SeedsToken.id];

  bool get isCitizen => _preferences.getBool(_kIsCitizen) ?? _kIsCitizenDefault;

  set inRecoveryMode(bool value) => _preferences.setBool(_kInRecoveryMode, value);

  set accountName(String? value) {
    final String newAccountName = value ?? '';
    final String oldAccountName = accountName;
    _preferences.setString(_kAccountName, newAccountName);
    _updateFirebaseToken(oldAccountName, newAccountName);
  }

  set privateKey(String? value) {
    _secureStorage.write(key: _kPrivateKey, value: value);
    if (value != null) {
      _privateKey = value;
    }
  }

  set passcode(String? value) {
    _secureStorage.write(key: _kPasscode, value: value);
    _passcode = value;
  }

  set passcodeActive(bool? value) {
    _secureStorage.write(key: _kPasscodeActive, value: value.toString());
    if (value != null) {
      _passcodeActive = value;
    }
  }

  set biometricActive(bool? value) {
    _secureStorage.write(key: _kBiometricActive, value: value.toString());
    if (value != null) {
      _biometricActive = value;
    }
  }

  set privateKeyBackedUp(bool? value) {
    _secureStorage.write(key: _kPrivateKeyBackedUp, value: value.toString());
    if (value != null) {
      _privateKeyBackedUp = value;
    }
  }

  set selectedFiatCurrency(String? value) {
    if (value != null) {
      _preferences.setString(_kSelectedFiatCurrency, value);
    }
  }

  set selectedToken(TokenModel token) {
    _preferences.setString(_kSelectedToken, token.symbol);
  }

  set tokensWhitelist(List<String> tokensList) {
    _preferences.setStringList(_kTokensWhiteList, tokensList);
  }

  set isCitizen(bool? value) {
    if (value != null) {
      _preferences.setBool(_kIsCitizen, value);
    }
  }

  Future<void> initialise() async {
    _preferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();

    // on iOS secure storage items are not deleted on app uninstall - must be deleted manually
    if (accountName.isEmpty && (_preferences.getBool(_kIsFirstRun) ?? true)) {
      await _secureStorage.deleteAll();
    }
    await _preferences.setBool(_kIsFirstRun, false);

    await _secureStorage.readAll().then((values) {
      _privateKey = values[_kPrivateKey];
      _privateKey ??= _migrateFromPrefs(_kPrivateKey);

      _passcode = values[_kPasscode];
      _passcode ??= _migrateFromPrefs(_kPasscode);

      if (values.containsKey(_kPasscodeActive)) {
        _passcodeActive = values[_kPasscodeActive] == 'true';
      } else {
        _passcodeActive = _kPasscodeActiveDefault;
      }

      if (values.containsKey(_kBiometricActive)) {
        _biometricActive = values[_kBiometricActive] == 'true';
      } else {
        _biometricActive = _kBiometricActiveDefault;
      }

      if (values.containsKey(_kPrivateKeyBackedUp)) {
        _privateKeyBackedUp = values[_kPrivateKeyBackedUp] == 'true';
      } else {
        _privateKeyBackedUp = false;
      }
    });
  }

  String? _migrateFromPrefs(String key) {
    final String? value = _preferences.get(key) as String?;
    if (value != null) {
      _secureStorage.write(key: key, value: value);
      _preferences.remove(key);
      print('Converted $key to secure storage');
    }
    return value;
  }

  void enableRecoveryMode({required String accountName, String? privateKey}) {
    inRecoveryMode = true;
    this.accountName = accountName;
    this.privateKey = privateKey;
  }

  void finishRecoveryProcess() => inRecoveryMode = false;

  void cancelRecoveryProcess() {
    inRecoveryMode = false;
    accountName = null;
    privateKey = null;
  }

  void savePasscode(String? passcode) => this.passcode = passcode;

  void saveAccount(String accountName, String privateKey) {
    this.accountName = accountName;
    this.privateKey = privateKey;
  }

  void savePrivateKeyBackedUp(bool value) => privateKeyBackedUp = value;

  void saveSelectedFiatCurrency(String value) => selectedFiatCurrency = value;

  void saveIsCitizen(bool value) => isCitizen = value;

  Future<void> removeAccount() async {
    _updateFirebaseToken(accountName, "");
    await _preferences.clear();
    await _secureStorage.deleteAll();
    _privateKey = null;
    _passcode = null;
    _passcodeActive = _kPasscodeActiveDefault;
    _biometricActive = _kBiometricActiveDefault;
  }

  String getPlatformCurrency() {
    final format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return format.currencyName ?? currencyDefaultCode;
  }

  void _updateFirebaseToken(String oldAccount, String newAccount) {
    if (oldAccount.isNotEmpty) {
      FirebaseMessageTokenRepository().removeFirebaseMessageToken(oldAccount);
    }
    if (newAccount.isNotEmpty) {
      FirebaseMessageTokenRepository().setFirebaseMessageToken(newAccount);
    }
  }
}

/// Singleton
_SettingsStorage settingsStorage = _SettingsStorage();
