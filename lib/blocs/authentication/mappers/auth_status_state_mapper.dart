import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';

class AuthStatusStateMapper {
  AuthenticationState mapResultToState(AuthenticationState currentState) {
    AuthStatus status = AuthStatus.unlocked;

    if (settingsStorage.passcode == null && settingsStorage.passcodeActive == true) {
      status = AuthStatus.emptyPasscode;
    }

    if (settingsStorage.passcode == null && settingsStorage.passcodeActive == false) {
      status = AuthStatus.unlocked;
    }

    if (settingsStorage.passcode != null && settingsStorage.passcodeActive == true) {
      status = AuthStatus.locked;
    }

    if (settingsStorage.accountName.isEmpty || settingsStorage.privateKey == null) {
      status = AuthStatus.emptyAccount;
    }

    if (settingsStorage.inRecoveryMode == true) {
      status = AuthStatus.recoveryMode;
    }

    return currentState.copyWith(authStatus: status);
  }
}
