import 'package:seeds/datasource/local/settings_storage.dart';

class StopRecoveryUseCase {
  void run() {
    settingsStorage.cancelRecoveryProcess();
  }
}
