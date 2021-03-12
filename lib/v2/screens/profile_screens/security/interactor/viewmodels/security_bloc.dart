import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc() : super(SecurityState.initial());

  @override
  Stream<SecurityState> mapEventToState(SecurityEvent event) async* {
    if (event is OnPinChanged) {
      yield state.copyWith(isSecurePin: !state.isSecurePin);
    }
    if (event is OnBiometricsChanged) {
      yield state.copyWith(isSecureBiometric: !state.isSecureBiometric);
    }
  }
}
