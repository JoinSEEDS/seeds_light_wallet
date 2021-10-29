import 'package:seeds/datasource/local/settings_storage.dart';

class StopRecoveryUseCase {
  Future<void> run() => settingsStorage.cancelRecoveryProcess();
}
