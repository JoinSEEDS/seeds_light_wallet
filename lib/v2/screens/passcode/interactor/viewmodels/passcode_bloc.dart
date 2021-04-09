import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/passcode/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
class PasscodeBloc extends Bloc<PasscodeEvent, PasscodeState> {
  final SecurityBloc securityBloc;
  final AuthenticationBloc authenticationBloc;

  PasscodeBloc({@required this.authenticationBloc, @required this.securityBloc}) : super(PasscodeState.initial());

  @override
  Stream<PasscodeState> mapEventToState(PasscodeEvent event) async* {
    if (event is DefineView) {
      yield state.copyWith(
        pageState: PageState.success,
        isCreateView: settingsStorage.passcode == null,
        isCreateMode: settingsStorage.passcode == null,
      );
    }
    if (event is OnVerifyPasscode) {
      if (state.isCreateMode) {
        yield state.copyWith(
          isValidPasscode: event.passcode == state.newPasscode,
          showInfoSnack: event.passcode == state.newPasscode ? null : true,
        );
      } else {
        yield state.copyWith(
          isValidPasscode: event.passcode == settingsStorage.passcode,
          showInfoSnack: event.passcode == settingsStorage.passcode ? null : true,
        );
      }
    }
    if (event is OnValidVerifyPasscode) {
      securityBloc?.add(const OnPinChanged());
      if (state.isCreateMode) {
        settingsStorage.savePasscode(state.newPasscode);
        if (securityBloc == null) {
          authenticationBloc.add(const PasscodeAuthenticated());
        }
      } else {
        if (securityBloc == null) {
          authenticationBloc.add(const PasscodeAuthenticated());
        }
      }
    }
    if (event is OnCreatePasscode) {
      yield state.copyWith(isCreateView: false, newPasscode: event.passcode);
    }
    if (event is ResetShowSnack) {
      yield state.copyWith(showInfoSnack: null);
    }
  }
}
