import 'package:seeds/v2/blocs/authentication/viewmodels/authentication_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';

class AuthStatusStateMapper {
  AuthenticationState mapResultToState(AuthenticationState currentState) {
    AuthStatus status = AuthStatus.unlocked;

    if (settingsStorage.passcode == null && settingsStorage.passcodeActive == null) {
      status = AuthStatus.emptyPasscode;
    }

    if ((settingsStorage.passcodeActive != null) &&
        (status == AuthStatus.emptyPasscode && !settingsStorage.passcodeActive)) {
      status = AuthStatus.unlocked;
    }

    if (settingsStorage.passcode != null && settingsStorage.passcodeActive != null) {
      status = AuthStatus.locked;
    }

    if (settingsStorage.accountName == null || settingsStorage.privateKey == null) {
      status = AuthStatus.emptyAccount;
    }

    if (settingsStorage.inRecoveryMode == true) {
      status = AuthStatus.recoveryMode;
    }

    return currentState.copyWith(authStatus: status);
  }
}
