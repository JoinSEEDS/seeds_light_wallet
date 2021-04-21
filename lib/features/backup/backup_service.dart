import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:share/share.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';

// class BackupService {

//   static const int BACKUP_REMINDER_MIN_AMOUNT = 0;
//   SettingsNotifier _settings;

//   BackupService();

//   bool get showReminder {
//     if(_settings.privateKeyBackedUp) {
//       return false;
//     } else {
//       final now = DateTime.now().millisecondsSinceEpoch;
//       final incrementalDelay = _settings.backupReminderCount * Duration.millisecondsPerSecond;
//       return _settings.backupLatestReminder + incrementalDelay < now;
//     }
//   }

//   void update(SettingsNotifier settings) {
//     this._settings = settings;
//   }

//   void remindLater() {
//     _settings.updateBackupLater();
//   }

//   void backup() {
//     Share.share(_settings.privateKey);
//     _settings.savePrivateKeyBackedUp(true);
//   }

// }

class BackupService {
  static const int BACKUP_REMINDER_MIN_AMOUNT = 0;

  BackupService();

  bool get showReminder {
    if (settingsStorage.privateKeyBackedUp) {
      return false;
    } else {
      final now = DateTime.now().millisecondsSinceEpoch;
      final incrementalDelay = settingsStorage.backupReminderCount * Duration.millisecondsPerSecond;
      return settingsStorage.backupLatestReminder! + incrementalDelay < now;
    }
  }

  void update(SettingsNotifier settings) {}

  void remindLater() {
    settingsStorage.updateBackupLater();
  }

  void backup() {
    Share.share(settingsStorage.privateKey!);
    settingsStorage.savePrivateKeyBackedUp(true);
  }
}
