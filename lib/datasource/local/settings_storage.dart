import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Keys
const String _kAccountName = 'accountName';
const String _kAccountsList = 'accountsList';
const String _kPrivateKey = 'privateKey';
const String _kPrivateKeysList = 'privateKeysList';
const String _kRecoveryWords = 'recoveryWords';
const String _kPasscode = 'passcode';
const String _kPasscodeActive = 'passcode_active';
const String _kBiometricActive = 'biometric_active';
const String _kPrivateKeyBackedUp = 'private_key_backed_up';
const String _kSelectedFiatCurrency = 'selected_fiat_currency';
const String _kSelectedToken = 'selected_token';
const String _kInRecoveryMode = 'in_recovery_mode';
const String _kRecoveryLink = 'recovery_link';
const String _kTokensWhiteList = 'tokens_whitelist';
const String _kIsCitizen = 'is_citizen';
const String _kIsVisitor = 'is_visitor';
const String _kIsFirstRun = 'is_first_run';
const String _kIsFirstTimeOnDelegateScreen = 'is_first_time_on_delegate_screen';
const String _kDateSinceRateAppPrompted = 'date_since_rate_app_prompted';
const String _kIsFirstTimeOnRegionsScreen = 'IsFirstTimeOnRegionsScreen';

class _SettingsStorage {
  late SharedPreferences _preferences;
  late FlutterSecureStorage _secureStorage;

  // These nullable fields below are initialized from
  // secure storage, to avoid call a Future often
  String? _privateKey;
  List<String>? _privateKeysList;
  String? _passcode;
  bool? _passcodeActive;
  bool? _biometricActive;
  List<String> _recoveryWords = [];

  factory _SettingsStorage() => _instance;

  _SettingsStorage._();

  static final _SettingsStorage _instance = _SettingsStorage._();

  String get accountName => _preferences.getString(_kAccountName) ?? '';

  List<String> get accountsList => _preferences.getStringList(_kAccountsList) ?? [];

  String? get privateKey => _privateKey;

  List<String> get privateKeysList => _privateKeysList ?? [];

  String? get passcode => _passcode;

  bool get passcodeActive => _passcodeActive ?? false;

  bool? get biometricActive => _biometricActive;

  bool get privateKeyBackedUp => _preferences.getBool(_kPrivateKeyBackedUp) ?? false; // <-- No used, need re-add PR 182

  String get selectedFiatCurrency => _preferences.getString(_kSelectedFiatCurrency) ?? getPlatformCurrency();

  TokenModel get selectedToken {
    var storedValue = _preferences.getString(_kSelectedToken);
    // Compatibility with old format: [contract]#[symbol]
    if (storedValue != null && storedValue.split("#").length < 3) {
      storedValue = "$storedValue#telos";
    }
    return TokenModel.fromId(storedValue ?? seedsToken.id);
  }

  bool get inRecoveryMode => _preferences.getBool(_kInRecoveryMode) ?? false;

  String get recoveryLink => _preferences.getString(_kRecoveryLink) ?? '';

  List<String> get tokensWhitelist => _preferences.getStringList(_kTokensWhiteList) ?? [seedsToken.id];

  bool get isCitizen => _preferences.getBool(_kIsCitizen) ?? false;

  bool get isFirstTimeOnDelegateScreen => _preferences.getBool(_kIsFirstTimeOnDelegateScreen) ?? false;

  bool get isFirstTimeOnRegionsScreen => _preferences.getBool(_kIsFirstTimeOnRegionsScreen) ?? true;

  List<String> get recoveryWords => _recoveryWords;

  int? get dateSinceRateAppPrompted => _preferences.getInt(_kDateSinceRateAppPrompted);

  set inRecoveryMode(bool value) => _preferences.setBool(_kInRecoveryMode, value);

  set recoveryLink(String? value) =>
      value == null ? _preferences.remove(_kRecoveryLink) : _preferences.setString(_kRecoveryLink, value);

  // ignore: avoid_setters_without_getters
  set _accountName(String? value) {
    // When start cancelRecoveryProcess funtion is fired a null value is recived.
    // if null arrives here the account name is saved with empty string (I think this is a bad practice)
    _preferences.setString(_kAccountName, value ?? '');
    // Retrieve accounts list
    final List<String> accts = accountsList;
    // If new account --> add to list
    // but check accountName is not a empty string to add
    if (!accountsList.contains(value) && accountName.isNotEmpty) {
      accts.add(accountName);
      // Save updated accounts list
      _preferences.setStringList(_kAccountsList, accts);
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
    if (value != null) {
      _preferences.setBool(_kPrivateKeyBackedUp, value);
    }
  }

  set selectedFiatCurrency(String? value) {
    if (value != null) {
      _preferences.setString(_kSelectedFiatCurrency, value);
    }
  }

  set selectedToken(TokenModel token) {
    _preferences.setString(_kSelectedToken, token.id);
  }

  set tokensWhitelist(List<String> tokensList) {
    _preferences.setStringList(_kTokensWhiteList, tokensList);
  }

  set isCitizen(bool? value) {
    if (value != null) {
      _preferences.setBool(_kIsCitizen, value);
    }
  }

  set isFirstTimeOnDelegateScreen(bool value) {
    _preferences.setBool(_kIsFirstTimeOnDelegateScreen, value);
  }

  set isFirstTimeOnRegionsScreen(bool value) {
    _preferences.setBool(_kIsFirstTimeOnRegionsScreen, value);
  }

  set dateSinceRateAppPrompted(int? value) {
    if (value != null) {
      _preferences.setInt(_kDateSinceRateAppPrompted, value);
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
      _privateKeysList = values[_kPrivateKeysList]?.split(',');

      _privateKey = values[_kPrivateKey];
      _privateKey ??= _migrateFromPrefs(_kPrivateKey); // <-- privateKey is not in pref

      _passcode = values[_kPasscode];
      _passcode ??= _migrateFromPrefs(_kPasscode); // <-- passcode is not in pref

      if (values.containsKey(_kPasscodeActive)) {
        _passcodeActive = values[_kPasscodeActive] == 'true';
      } else {
        _passcodeActive = true;
      }

      if (values.containsKey(_kRecoveryWords)) {
        _recoveryWords = values[_kRecoveryWords]!.split(',');
      }

      if (values.containsKey(_kBiometricActive)) {
        _biometricActive = values[_kBiometricActive] == 'true';
      } else {
        _biometricActive = false;
      }
    });
  }

  // Used to migrate old settings versions
  String? _migrateFromPrefs(String key) {
    final String? value = _preferences.get(key) as String?;
    if (value != null) {
      _secureStorage.write(key: key, value: value);
      _preferences.remove(key);
      print('Converted $key to secure storage');
    }
    return value;
  }

  Future<void> startRecoveryProcess({
    required String accountName,
    required AuthDataModel authData,
    required String recoveryLink,
  }) async {
    inRecoveryMode = true;
    _accountName = accountName;
    this.recoveryLink = recoveryLink;
    await _savePrivateKey(authData.eOSPrivateKey.toString());
    await _saveRecoverWords(authData.words);
  }

  void finishRecoveryProcess() {
    privateKeyBackedUp = false;
    inRecoveryMode = false;
    recoveryLink = null;
  }

  /// Notice this function it's also called on `Import (login screen)`
  /// and `Singup`. To cancel any recover process previously started
  Future<void> cancelRecoveryProcess() async {
    await _preferences.clear();
    await _secureStorage.deleteAll();
    _accountName = null;
  }

  void enablePasscode(String? passcode) {
    this.passcode = passcode;
    passcodeActive = true;
  }

  void disablePasscode() {
    passcode = null;
    passcodeActive = false;
    biometricActive = false;
  }

  Future<void> _savePrivateKey(String privateKey) async {
    if (privateKey.isNotEmpty) {
      // Update storage privateKey
      await _secureStorage.write(key: _kPrivateKey, value: privateKey);
      // Update local privateKey
      _privateKey = privateKey;
      // Verify if its a new privateKey
      final List<String> pkeys = _privateKeysList ?? [];
      // If new private key --> add to list
      if (!pkeys.contains(privateKey)) {
        pkeys.add(privateKey);
        // Save updated private keys list
        await _secureStorage.write(key: _kPrivateKeysList, value: pkeys.join(','));
        // Update local private keys list
        _privateKeysList = pkeys;
      }
    }
  }

  Future<void> _saveRecoverWords(List<String> words) async {
    final String newWords = words.join('-');
    if (words.isNotEmpty && newWords.isNotEmpty) {
      final List<String> wordsList = _recoveryWords;
      // If new words --> add to list
      if (!wordsList.contains(newWords)) {
        wordsList.add(newWords);
        // Save updated private keys list
        await _secureStorage.write(key: _kRecoveryWords, value: wordsList.join(','));
        // Update local field
        _recoveryWords = wordsList;
      }
    }
  }

  Future<void> saveAccount(String accountName, AuthDataModel authData) async {
    _accountName = accountName;
    privateKeyBackedUp = false;
    await _savePrivateKey(authData.eOSPrivateKey.toString());
    await _saveRecoverWords(authData.words);
  }

  /// Update current accout name, private key and remove some pref
  Future<void> switchAccount(String accountName, AuthDataModel authData) async {
    privateKeyBackedUp = false;
    _accountName = accountName;
    await Future.wait([
      _savePrivateKey(authData.eOSPrivateKey.toString()),
      _preferences.remove(_kSelectedFiatCurrency),
      _preferences.remove(_kSelectedToken),
      _preferences.remove(_kTokensWhiteList),
      _preferences.remove(_kIsCitizen),
      _preferences.remove(_kIsVisitor),
      _preferences.remove(_kIsFirstTimeOnDelegateScreen),
    ]);
  }

  // ignore: use_setters_to_change_properties
  void savePrivateKeyBackedUp(bool value) => privateKeyBackedUp = value;

  // ignore: use_setters_to_change_properties
  void saveSelectedFiatCurrency(String value) => selectedFiatCurrency = value;

  // ignore: use_setters_to_change_properties
  void saveCitizenshipStatus(ProfileStatus status) {
    if (status == ProfileStatus.citizen) {
      isCitizen = true;
    } else if (status == ProfileStatus.visitor) {
      isCitizen = false;
    } else if (status == ProfileStatus.resident) {
      isCitizen = false;
    }
  }

  // ignore: use_setters_to_change_properties
  void saveFirstTimeOnDelegateScreen(bool value) => isFirstTimeOnDelegateScreen = value;

  // ignore: use_setters_to_change_properties
  void saveDateSinceRateAppPrompted(int value) => dateSinceRateAppPrompted = value;

  Future<void> removeAccount() async {
    await _preferences.clear();
    await _secureStorage.deleteAll();
    _privateKey = null;
    _privateKeysList = null;
    _passcode = null;
    _passcodeActive = true;
    _biometricActive = false;
    _recoveryWords = [];
  }

  String getPlatformCurrency() {
    final format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return format.currencyName ?? currencyDefaultCode;
  }
}

/// Singleton
_SettingsStorage settingsStorage = _SettingsStorage();
