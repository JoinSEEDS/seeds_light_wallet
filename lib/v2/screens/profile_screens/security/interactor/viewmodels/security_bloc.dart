import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final SettingsNotifier settingsNotifier;
  final AuthNotifier authNotifier;
  SecurityBloc({@required this.settingsNotifier, @required this.authNotifier}) : super(SecurityState.initial());

  @override
  Stream<SecurityState> mapEventToState(SecurityEvent event) async* {
    if (event is SetUpInitialValues) {
      yield state.copyWith(
        pageState: PageState.success,
        isSecurePin: settingsNotifier.passcodeActive,
        isSecureBiometric: true,
      );
    }
    if (event is OnPinChanged) {
      if (state.isSecurePin) {
        yield state.copyWith(isSecurePin: false);
        settingsNotifier.passcode = null;
        settingsNotifier.passcodeActive = false;
        authNotifier.disablePasscode();
        authNotifier.resetPasscode();
      } else {
        yield state.copyWith(isSecurePin: true);
        settingsNotifier.passcodeActive = true;
      }
    }
    if (event is OnBiometricsChanged) {
      yield state.copyWith(isSecureBiometric: !state.isSecureBiometric);
    }
  }
}
