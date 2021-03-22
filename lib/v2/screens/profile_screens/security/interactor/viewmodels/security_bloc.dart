import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  StreamSubscription<bool> _hasGuardianNotificationPending;

  SecurityBloc() : super(SecurityState.initial()) {
    _hasGuardianNotificationPending =
        FirebaseDatabaseService().hasGuardianNotificationPending(settingsStorage.accountName).listen(
              (value) => add(ShowNotificationBadge(value: value)),
            );
  }

  @override
  Stream<SecurityState> mapEventToState(SecurityEvent event) async* {
    if (event is ShowNotificationBadge) {
      yield state.copyWith(hasNotification: event.value);
    }
    if (event is OnPinChanged) {
      yield state.copyWith(isSecurePin: !state.isSecurePin);
    }
    if (event is OnBiometricsChanged) {
      yield state.copyWith(isSecureBiometric: !state.isSecureBiometric);
    }
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending?.cancel();
    return super.close();
  }
}
