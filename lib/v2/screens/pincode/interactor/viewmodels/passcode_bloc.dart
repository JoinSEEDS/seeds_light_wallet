import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/screens/pincode/interactor/viewmodels/bloc.dart';

/// --- BLOC
class PasscodeBloc extends Bloc<PasscodeEvent, PasscodeState> {
  final SettingsNotifier settingsNotifier;
  final AuthNotifier authNotifier;
  PasscodeBloc({@required this.settingsNotifier, this.authNotifier}) : super(PasscodeState.initial());

  @override
  Stream<PasscodeState> mapEventToState(PasscodeEvent event) async* {
    if (event is DefineView) {
      yield state.copyWith(isCreateView: authNotifier.status == AuthStatus.emptyPasscode);
    }
    if (event is OnVerifyPasscode) {
      yield state.copyWith(isValidPasscode: event.passcode == settingsNotifier.passcode);
    }
    if (event is OnValidPasscode) {
      authNotifier.unlockWallet();
    }
  }
}
