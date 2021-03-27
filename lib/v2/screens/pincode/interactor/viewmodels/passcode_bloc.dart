import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/screens/pincode/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
class PasscodeBloc extends Bloc<PasscodeEvent, PasscodeState> {
  final SettingsNotifier settingsNotifier;
  final AuthNotifier authNotifier;
  final SecurityBloc securityBloc;

  PasscodeBloc({@required this.settingsNotifier, this.authNotifier, this.securityBloc})
      : super(PasscodeState.initial());

  @override
  Stream<PasscodeState> mapEventToState(PasscodeEvent event) async* {
    if (event is DefineView) {
      yield state.copyWith(isCreateView: settingsNotifier.passcode == null);
    }
    if (event is OnVerifyPasscode) {
      yield state.copyWith(isValidPasscode: event.passcode == settingsNotifier.passcode);
    }
    if (event is OnValidVerifyPasscode) {
      securityBloc?.add(const OnPinChanged());
      authNotifier.unlockWallet();
    }
    if (event is OnSavePasscode) {
      settingsNotifier.savePasscode(event.passcode);
      yield state.copyWith(isCreateView: settingsNotifier.passcode == null);
    }
  }
}
