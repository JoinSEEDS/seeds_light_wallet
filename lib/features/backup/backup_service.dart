import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:share/share.dart';

class BackupService {
  static const int BACKUP_REMINDER_MIN_AMOUNT = 0;
  SettingsNotifier _settings;

  BackupService();

  bool get showReminder {
    // otherwise throws Failed assertion: boolean expression must not be null
    if (_settings.privateKeyBackedUp == null || _settings.privateKeyBackedUp == true) {
      return false;
    } else {
      final now = DateTime.now().millisecondsSinceEpoch;
      final incrementalDelay = _settings.backupReminderCount * Duration.millisecondsPerSecond;
      return _settings.backupLatestReminder + incrementalDelay < now;
    }
  }

  void update(SettingsNotifier settings) {
    this._settings = settings;
  }

  void remindLater() {
    _settings.updateBackupLater();
  }

  void backup() {
    Share.share(_settings.privateKey);
    _settings.savePrivateKeyBackedUp(true);
  }
}
