import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _SettingsStorage {
  _SettingsStorage._();

  factory _SettingsStorage() => _instance;

  static final _SettingsStorage _instance = _SettingsStorage._();

  static const ACCOUNT_NAME = 'accountName';
  static const PRIVATE_KEY = 'privateKey';
  static const PASSCODE = 'passcode';
  static const PASSCODE_ACTIVE = 'passcode_active';
  static const PASSCODE_ACTIVE_DEFAULT = true;
  static const BIOMETRIC_ACTIVE = 'biometric_active';
  static const BIOMETRIC_ACTIVE_DEFAULT = false;
  static const PRIVATE_KEY_BACKED_UP = 'private_key_backed_up';
  static const BACKUP_LATEST_REMINDER = 'backup_latest_reminder';
  static const BACKUP_REMINDER_COUNT = 'backup_reminder_count';
  static const SELECTED_FIAT_CURRENCY = 'selected_fiat_currency';
  static const IN_RECOVERY_MODE = 'in_recovery_mode';
  static const GUARDIAN_TUTORIAL_SHOWN = 'guardian_tutorial_shown';
  static const TOKENS_WHITELIST = 'tokens_whitelist';
  static const IS_CITIZEN = 'is_citizen';
  static const IS_CITIZEN_DEFAULT = false;
  static const IS_FIRST_RUN = "is_first_run";

  String? _privateKey;
  String? _passcode;
  bool? _passcodeActive;
  bool? _biometricActive;
  bool? _privateKeyBackedUp;
  int? _backupLatestReminder;
  int? _backupReminderCount;

  String get accountName => _preferences.getString(ACCOUNT_NAME) ?? "";

  String? get privateKey => _privateKey;

  String? get passcode => _passcode;

  bool? get passcodeActive => _passcodeActive;

  bool? get biometricActive => _biometricActive;

  bool get privateKeyBackedUp => _privateKeyBackedUp ?? false;

  int? get backupLatestReminder => _backupLatestReminder ?? 0;

  int get backupReminderCount => _backupReminderCount ?? 0;

  String get selectedFiatCurrency => _preferences.getString(SELECTED_FIAT_CURRENCY) ?? getPlatformCurrency();

  bool get inRecoveryMode => _preferences.getBool(IN_RECOVERY_MODE) ?? false;

  bool get guardianTutorialShown => _preferences.getBool(GUARDIAN_TUTORIAL_SHOWN)!;

  List<String> get tokensWhitelist => _preferences.getStringList(TOKENS_WHITELIST) ?? [SeedsToken.id];

  bool get isCitizen => _preferences.getBool(IS_CITIZEN) ?? IS_CITIZEN_DEFAULT;

  set inRecoveryMode(bool value) => _preferences.setBool(IN_RECOVERY_MODE, value);

  set accountName(String? value) => _preferences.setString(ACCOUNT_NAME, value ?? '');

  set privateKey(String? value) {
    _secureStorage.write(key: PRIVATE_KEY, value: value);
    if (value != null) {
      _privateKey = value;
    }
  }

  set passcode(String? value) {
    _secureStorage.write(key: PASSCODE, value: value);
    _passcode = value;
  }

  set passcodeActive(bool? value) {
    _secureStorage.write(key: PASSCODE_ACTIVE, value: value.toString());
    if (value != null) {
      _passcodeActive = value;
    }
  }

  set biometricActive(bool? value) {
    _secureStorage.write(key: BIOMETRIC_ACTIVE, value: value.toString());
    if (value != null) {
      _biometricActive = value;
    }
  }

  set privateKeyBackedUp(bool? value) {
    _secureStorage.write(key: PRIVATE_KEY_BACKED_UP, value: value.toString());
    if (value != null) {
      _privateKeyBackedUp = value;
    }
  }

  set backupLatestReminder(int? value) {
    _secureStorage.write(key: BACKUP_LATEST_REMINDER, value: value.toString());
    if (value != null) {
      _backupLatestReminder = value;
    }
  }

  set backupReminderCount(int value) {
    _secureStorage.write(key: BACKUP_REMINDER_COUNT, value: value.toString());
    _backupReminderCount = value;
  }

  set selectedFiatCurrency(String? value) {
    if (value != null) {
      _preferences.setString(SELECTED_FIAT_CURRENCY, value);
    }
  }

  set guardianTutorialShown(bool? shown) {
    if (shown != null) {
      _preferences.setBool(GUARDIAN_TUTORIAL_SHOWN, shown);
    }
  }

  set tokensWhitelist(List<String> tokensList) {
    _preferences.setStringList(TOKENS_WHITELIST, tokensList);
  }

  set isCitizen(bool? value) {
    if (value != null) {
      _preferences.setBool(IS_CITIZEN, value);
    }
  }

  late SharedPreferences _preferences;
  late FlutterSecureStorage _secureStorage;

  void initialise() async {
    _preferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();

    // on iOS secure storage items are not deleted on app uninstall - must be deleted manually
    if (accountName.isEmpty && (_preferences.getBool(IS_FIRST_RUN) ?? true)) {
      await _secureStorage.deleteAll();
    }
    await _preferences.setBool(IS_FIRST_RUN, false);

    await _secureStorage.readAll().then((values) {
      _privateKey = values[PRIVATE_KEY];
      _privateKey ??= _migrateFromPrefs(PRIVATE_KEY);

      _passcode = values[PASSCODE];
      _passcode ??= _migrateFromPrefs(PASSCODE);

      if (values.containsKey(PASSCODE_ACTIVE)) {
        _passcodeActive = values[PASSCODE_ACTIVE] == 'true';
      } else {
        _passcodeActive = PASSCODE_ACTIVE_DEFAULT;
      }

      if (values.containsKey(BIOMETRIC_ACTIVE)) {
        _biometricActive = values[BIOMETRIC_ACTIVE] == 'true';
      } else {
        _biometricActive = BIOMETRIC_ACTIVE_DEFAULT;
      }

      if (values.containsKey(PRIVATE_KEY_BACKED_UP)) {
        _privateKeyBackedUp = values[PRIVATE_KEY_BACKED_UP] == 'true';
      } else {
        _privateKeyBackedUp = false;
      }

      if (values.containsKey(BACKUP_LATEST_REMINDER)) {
        _backupLatestReminder = int.parse(values[BACKUP_LATEST_REMINDER]!);
      } else {
        _backupLatestReminder = 0;
      }

      if (values.containsKey(BACKUP_REMINDER_COUNT)) {
        _backupReminderCount = int.parse(values[BACKUP_REMINDER_COUNT]!);
      } else {
        _backupReminderCount = 0;
      }
    });
  }

  String? _migrateFromPrefs(String key) {
    String? value = _preferences.get(key) as String?;
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

  void finishRecoveryProcess() {
    inRecoveryMode = false;
  }

  void cancelRecoveryProcess() {
    inRecoveryMode = false;
    accountName = null;
    privateKey = null;
  }

  void savePasscode(String? passcode) {
    this.passcode = passcode;
  }

  void savePasscodeActive(bool value) {
    passcodeActive = value;
    if (!value) {
      passcode = null;
    }
  }

  void saveAccount(String accountName, String privateKey) {
    this.accountName = accountName;
    this.privateKey = privateKey;
  }

  void savePrivateKeyBackedUp(bool value) {
    privateKeyBackedUp = value;
  }

  void saveSelectedFiatCurrency(String value) {
    selectedFiatCurrency = value;
  }

  void saveGuardianTutorialShown(bool value) {
    guardianTutorialShown = value;
  }

  void updateBackupLater() {
    backupLatestReminder = DateTime.now().millisecondsSinceEpoch;
    backupReminderCount++;
  }

  void saveIsCitizen(bool value) {
    isCitizen = value;
  }

  void removeAccount() {
    _preferences.remove(ACCOUNT_NAME);
    _secureStorage.delete(key: ACCOUNT_NAME);
    _preferences.remove(PRIVATE_KEY);
    _secureStorage.delete(key: PRIVATE_KEY);
    _privateKey = null;
    _preferences.remove(PASSCODE);
    _secureStorage.delete(key: PASSCODE);
    _passcode = null;
    _secureStorage.delete(key: PASSCODE_ACTIVE);
    _passcodeActive = PASSCODE_ACTIVE_DEFAULT;
    _secureStorage.delete(key: BIOMETRIC_ACTIVE);
    _biometricActive = BIOMETRIC_ACTIVE_DEFAULT;
    _secureStorage.delete(key: PRIVATE_KEY_BACKED_UP);
    _secureStorage.delete(key: BACKUP_LATEST_REMINDER);
    _backupLatestReminder = 0;
    _secureStorage.delete(key: BACKUP_REMINDER_COUNT);
    _preferences.remove(IS_CITIZEN);
    _preferences.remove(TOKENS_WHITELIST);
    _preferences.remove(GUARDIAN_TUTORIAL_SHOWN);
    _preferences.remove(IN_RECOVERY_MODE);
    _backupReminderCount = 0;
  }

  String getPlatformCurrency() {
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
    return format.currencyName ?? 'USD';
  }
}

/// Singleton
_SettingsStorage settingsStorage = _SettingsStorage();
