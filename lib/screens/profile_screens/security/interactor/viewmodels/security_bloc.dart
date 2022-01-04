import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/guardian_notification_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/should_show_recovery_phrase_features_use_case.dart';
import 'package:seeds/screens/profile_screens/security/interactor/mappers/guardians_state_mapper.dart';
import 'package:seeds/screens/profile_screens/security/interactor/usecases/guardians_usecase.dart';

part 'security_event.dart';
part 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final AuthenticationBloc _authenticationBloc;
  late StreamSubscription<bool> _hasGuardianNotificationPending;
  late StreamSubscription<List<GuardianModel>> _guardians;
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();

  SecurityBloc(this._authenticationBloc)
      : super(SecurityState.initial(ShouldShowRecoveryPhraseFeatureUseCase().shouldShowRecoveryPhrase())) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShouldShowNotificationBadge(value: value)));

    _guardians = GuardiansUseCase().guardians.listen((value) => add(OnLoadingGuardians(guardians: value)));

    on<SetUpInitialValues>(_setUpInitialValues);
    on<ShouldShowNotificationBadge>((event, emit) => emit(state.copyWith(hasNotification: event.value)));
    on<OnLoadingGuardians>(_onLoadingGuardians);
    on<OnGuardiansCardTapped>(_onGuardiansCardTapped);
    on<OnPasscodePressed>(_onPasscodePressed);
    on<OnBiometricPressed>(_onBiometricPressed);
    on<ResetNavigateToVerification>((_, emit) => emit(state.copyWith()));
    on<OnValidVerification>(_onValidVerification);
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending.cancel();
    _guardians.cancel();
    return super.close();
  }

  Stream<bool> get isGuardianContractInitialized {
    return _repository.isGuardiansInitialized(settingsStorage.accountName);
  }

  void _setUpInitialValues(SetUpInitialValues event, Emitter<SecurityState> emit) {
    emit(state.copyWith(
      pageState: PageState.success,
      isSecurePasscode: settingsStorage.passcodeActive,
      isSecureBiometric: settingsStorage.biometricActive,
    ));
  }

  Future<void> _onLoadingGuardians(OnLoadingGuardians event, Emitter<SecurityState> emit) async {
    final bool isGuardianInitialized = await isGuardianContractInitialized.first;
    emit(GuardianStateMapper().mapResultToState(isGuardianInitialized, event.guardians, state));
  }

  Future<void> _onGuardiansCardTapped(OnGuardiansCardTapped event, Emitter<SecurityState> emit) async {
    emit(state.copyWith()); //reset
    if (state.hasNotification) {
      await FirebaseDatabaseGuardiansRepository().removeGuardianNotification(settingsStorage.accountName);
    }
    emit(state.copyWith(navigateToGuardians: true));
  }

  void _onPasscodePressed(OnPasscodePressed event, Emitter<SecurityState> emit) {
    emit(state.copyWith(navigateToVerification: true, currentChoice: CurrentChoice.passcodeCard));
  }

  void _onBiometricPressed(OnBiometricPressed event, Emitter<SecurityState> emit) {
    if (state.isSecureBiometric!) {
      emit(state.copyWith(navigateToVerification: true, currentChoice: CurrentChoice.biometricCard));
    } else {
      emit(state.copyWith(isSecureBiometric: true));
      _authenticationBloc.add(const EnableBiometric());
    }
  }

  void _onValidVerification(OnValidVerification event, Emitter<SecurityState> emit) {
    switch (state.currentChoice) {
      case CurrentChoice.passcodeCard:
        if (state.isSecurePasscode!) {
          emit(state.copyWith(isSecurePasscode: false, isSecureBiometric: false));
          _authenticationBloc.add(const DisablePasscode());
        } else {
          emit(state.copyWith(isSecurePasscode: true));
        }
        break;
      case CurrentChoice.biometricCard:
        emit(state.copyWith(isSecureBiometric: false));
        _authenticationBloc.add(const DisableBiometric());
        break;
      default:
        return;
    }
  }
}
