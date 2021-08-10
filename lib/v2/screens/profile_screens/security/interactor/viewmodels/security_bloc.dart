import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/shared_use_cases/guardian_notification_use_case.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/mappers/guardians_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/usecases/guardians_usecase.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final AuthenticationBloc _authenticationBloc;
  late StreamSubscription<bool> _hasGuardianNotificationPending;
  late StreamSubscription<List<GuardianModel>> _guardians;
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();

  SecurityBloc({required AuthenticationBloc authenticationBloc})
      : _authenticationBloc = authenticationBloc,
        super(SecurityState.initial()) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShouldShowNotificationBadge(value: value)));

       _guardians = GuardiansUseCase()
        .guardians
        .listen((value) => add(OnLoadingGuardians(guardians: value)));
  }

  Stream<bool> get isGuardianContractInitialized {
    return _repository.isGuardiansInitialized(settingsStorage.accountName);
  }

  @override
  Stream<SecurityState> mapEventToState(SecurityEvent event) async* {
    if (event is SetUpInitialValues) {
      yield state.copyWith(
        pageState: PageState.success,
        isSecurePasscode: settingsStorage.passcodeActive,
        isSecureBiometric: settingsStorage.biometricActive,
      );
    }
    if (event is ShouldShowNotificationBadge) {
      yield state.copyWith(hasNotification: event.value);
    }
    if (event is OnLoadingGuardians) {
      bool isGuardianInitialized = await isGuardianContractInitialized.first;
      yield GuardianStateMapper().mapResultToState(isGuardianInitialized, event.guardians, state);
    }
    if (event is OnGuardiansCardTapped) {
      yield state.copyWith(navigateToGuardians: null); //reset
      if (state.hasNotification) {
        await FirebaseDatabaseGuardiansRepository().removeGuardianNotification(settingsStorage.accountName);
      }
      yield state.copyWith(navigateToGuardians: true);
    }
    if (event is OnPasscodePressed) {
      yield state.copyWith(navigateToVerification: true, currentChoice: CurrentChoice.passcodeCard);
    }
    if (event is OnBiometricPressed) {
      if (state.isSecureBiometric!) {
        yield state.copyWith(navigateToVerification: true, currentChoice: CurrentChoice.biometricCard);
      } else {
        yield state.copyWith(isSecureBiometric: true);
        _authenticationBloc.add(const EnableBiometric());
      }
    }
    if (event is ResetNavigateToVerification) {
      yield state.copyWith(navigateToVerification: null); //reset
    }
    if (event is OnValidVerification) {
      switch (state.currentChoice) {
        case CurrentChoice.passcodeCard:
          if (state.isSecurePasscode!) {
            yield state.copyWith(isSecurePasscode: false, isSecureBiometric: false);
            _authenticationBloc.add(const DisablePasscode());
          } else {
            yield state.copyWith(isSecurePasscode: true);
          }
          break;
        case CurrentChoice.biometricCard:
          yield state.copyWith(isSecureBiometric: false);
          _authenticationBloc.add(const DisableBiometric());
          break;
        default:
          return;
      }
    }
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending.cancel();
    _guardians.cancel();
    return super.close();
  }
}
