import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  static const PRIVATE_KEY_BACKED_UP = 'private_key_backed_up';
  static const BACKUP_LATEST_REMINDER = 'backup_latest_reminder';
  static const BACKUP_REMINDER_COUNT = 'backup_reminder_count';
  static const SELECTED_FIAT_CURRENCY = 'selected_fiat_currency';
  static const IN_RECOVERY_MODE = 'in_recovery_mode';
  static const GUARDIAN_TUTORIAL_SHOWN = 'guardian_tutorial_shown';

  String _privateKey;
  String _passcode;
  bool _passcodeActive;
  bool _privateKeyBackedUp;
  int _backupLatestReminder;
  int _backupReminderCount;

  bool get isInitialized => _preferences != null;

  String get accountName => _preferences?.getString(ACCOUNT_NAME);

  String get privateKey => _privateKey;

  String get passcode => _passcode;

  bool get passcodeActive => _passcodeActive;

  bool get privateKeyBackedUp => _privateKeyBackedUp;

  int get backupLatestReminder => _backupLatestReminder;

  int get backupReminderCount => _backupReminderCount;

  String get selectedFiatCurrency => _preferences?.getString(SELECTED_FIAT_CURRENCY);

  bool get inRecoveryMode => _preferences?.getBool(IN_RECOVERY_MODE);

  bool get guardianTutorialShown => _preferences?.getBool(GUARDIAN_TUTORIAL_SHOWN);

  set inRecoveryMode(bool value) => _preferences?.setBool(IN_RECOVERY_MODE, value);

  set accountName(String value) => _preferences?.setString(ACCOUNT_NAME, value);

  set privateKey(String value) {
    _secureStorage.write(key: PRIVATE_KEY, value: value);
    _privateKey = value;
  }

  set passcode(String value) {
    _secureStorage.write(key: PASSCODE, value: value);
    _passcode = value;
  }

  set passcodeActive(bool value) {
    _secureStorage.write(key: PASSCODE_ACTIVE, value: value.toString());
    _passcodeActive = value;
  }

  set privateKeyBackedUp(bool value) {
    _secureStorage.write(key: PRIVATE_KEY_BACKED_UP, value: value.toString());
    _privateKeyBackedUp = value;
  }

  set backupLatestReminder(int value) {
    _secureStorage.write(key: BACKUP_LATEST_REMINDER, value: value.toString());
    _backupLatestReminder = value;
  }

  set backupReminderCount(int value) {
    _secureStorage.write(key: BACKUP_REMINDER_COUNT, value: value.toString());
    _backupReminderCount = value;
  }

  set selectedFiatCurrency(String value) {
    _preferences.setString(SELECTED_FIAT_CURRENCY, value);
  }

  set guardianTutorialShown(bool shown) {
    _preferences.setBool(GUARDIAN_TUTORIAL_SHOWN, shown);
  }

  SharedPreferences _preferences;
  FlutterSecureStorage _secureStorage;

  void initialise() async {
    _preferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();
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

      if (values.containsKey(PRIVATE_KEY_BACKED_UP)) {
        _privateKeyBackedUp = values[PRIVATE_KEY_BACKED_UP] == 'true';
      } else {
        _privateKeyBackedUp = false;
      }

      if (values.containsKey(BACKUP_LATEST_REMINDER)) {
        _backupLatestReminder = int.parse(values[BACKUP_LATEST_REMINDER]);
      } else {
        _backupLatestReminder = 0;
      }

      if (values.containsKey(BACKUP_REMINDER_COUNT)) {
        _backupReminderCount = int.parse(values[BACKUP_REMINDER_COUNT]);
      } else {
        _backupReminderCount = 0;
      }
    });
  }

  String _migrateFromPrefs(String key) {
    String value = _preferences.get(key);
    if (value != null) {
      _secureStorage.write(key: key, value: value);
      _preferences?.remove(key);
      print('Converted $key to secure storage');
    }
    return value;
  }

  void enableRecoveryMode({String accountName, String privateKey}) {
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

  void savePasscode(String passcode) {
    this.passcode = passcode;
  }

  void savePasscodeActive(bool value) {
    passcodeActive = value;
    if (!passcodeActive) {
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

  void removeAccount() {
    _preferences?.remove(ACCOUNT_NAME);
    _secureStorage.delete(key: ACCOUNT_NAME);
    _preferences?.remove(PRIVATE_KEY);
    _secureStorage.delete(key: PRIVATE_KEY);
    _privateKey = null;
    _preferences?.remove(PASSCODE);
    _secureStorage.delete(key: PASSCODE);
    _passcode = null;
    _secureStorage.delete(key: PASSCODE_ACTIVE);
    _passcodeActive = PASSCODE_ACTIVE_DEFAULT;
    _secureStorage.delete(key: PRIVATE_KEY_BACKED_UP);
    _secureStorage.delete(key: BACKUP_LATEST_REMINDER);
    _backupLatestReminder = 0;
    _secureStorage.delete(key: BACKUP_REMINDER_COUNT);
    _backupReminderCount = 0;
  }
}

/// Singleton
_SettingsStorage settingsStorage = _SettingsStorage();
