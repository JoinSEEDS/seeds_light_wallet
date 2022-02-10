import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/mappers/activate_guardian_state_mapper.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/mappers/init_guardians_state_mapper.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/mappers/onboarding_dialogs_state_mapper.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/mappers/remove_guardian_state_mapper.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/get_guardians_usecase.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/init_guardians_usecase.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/remove_guardian_usecase.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/page_commands.dart';

part 'guardians_event.dart';

part 'guardians_state.dart';

class GuardiansBloc extends Bloc<GuardiansEvent, GuardiansState> {
  final GetGuardiansUseCase _userCase = GetGuardiansUseCase();
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();

  GuardiansBloc() : super(GuardiansState.initial()) {
    on<InitGuardians>(_initGuardians);
    on<OnAddGuardiansTapped>(_onAddGuardiansTapped);
    on<OnAcceptGuardianTapped>(_onAcceptGuardianTapped);
    on<OnCancelGuardianRequestTapped>(_onCancelGuardianRequestTapped);
    on<OnDeclineGuardianTapped>(_onDeclineGuardianTapped);
    on<OnGuardianRowTapped>(_onGuardianRowTapped);
    on<OnStopRecoveryForUser>(_onStopRecoveryForUser);
    on<OnRemoveGuardianTapped>(_onRemoveGuardianTapped);
    on<InitOnboardingGuardian>((_, emit) => emit(OnboardingDialogsStateMapper().mapResultToState(state, 1)));
    on<OnNextGuardianOnboardingTapped>(_onNextGuardianOnboardingTapped);
    on<OnPreviousGuardianOnboardingTapped>(_onPreviousGuardianOnboardingTapped);
    on<OnGuardianReadyForActivation>(_onGuardianReadyForActivation);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Stream<List<GuardianModel>> get guardians => _userCase.getGuardians();

  Stream<bool> get isGuardianContractInitialized {
    return _repository.isGuardiansInitialized(settingsStorage.accountName);
  }

  Future<void> _initGuardians(InitGuardians event, Emitter<GuardiansState> emit) async {
    if (event.myGuardians.length < 3) {
      emit(state.copyWith(pageCommand: ShowMessage("Minimum 3 guardians needed")));
    } else {
      emit(state.copyWith(pageState: PageState.loading));
      final result = await InitGuardiansUseCase().initGuardians(event.myGuardians);
      emit(InitGuardiansStateMapper().mapResultToState(state, result));
    }
  }

  Future<void> _onAddGuardiansTapped(OnAddGuardiansTapped event, Emitter<GuardiansState> emit) async {
    emit(state.copyWith(isAddGuardianButtonLoading: true));
    final List<GuardianModel> results = await guardians.first;
    results.retainWhere((element) => element.type == GuardianType.myGuardian);
    emit(state.copyWith(
        isAddGuardianButtonLoading: false,
        pageCommand: NavigateToRouteWithArguments(
          route: Routes.selectGuardians,
          arguments: results,
        )));
  }

  Future<void> _onAcceptGuardianTapped(OnAcceptGuardianTapped event, Emitter<GuardiansState> emit) async {
    await _repository.acceptGuardianRequestedMe(
        currentUserId: settingsStorage.accountName, friendId: event.guardianAccount);
  }

  Future<void> _onCancelGuardianRequestTapped(OnCancelGuardianRequestTapped event, Emitter<GuardiansState> emit) async {
    await _repository.cancelGuardianRequest(
        currentUserId: settingsStorage.accountName, friendId: event.guardianAccount);
  }

  Future<void> _onDeclineGuardianTapped(OnDeclineGuardianTapped event, Emitter<GuardiansState> emit) async {
    await _repository.declineGuardianRequestedMe(
        currentUserId: settingsStorage.accountName, friendId: event.guardianAccount);
  }

  void _onGuardianRowTapped(OnGuardianRowTapped event, Emitter<GuardiansState> emit) {
    switch (event.guardian.type) {
      case GuardianType.myGuardian:
        emit(myGuardianCase(event.guardian));
        break;
      case GuardianType.imGuardian:
        // Nothing to do here.
        emit(state);
        break;
    }
  }

  Future<void> _onStopRecoveryForUser(OnStopRecoveryForUser event, Emitter<GuardiansState> emit) async {
    await _repository.stopRecoveryForUser(settingsStorage.accountName);
  }

  Future<void> _onRemoveGuardianTapped(OnRemoveGuardianTapped event, Emitter<GuardiansState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final result = await RemoveGuardianUseCase().removeGuardian(event.guardian);
    emit(RemoveGuardianStateMapper().mapResultToState(state, result));
  }

  void _onNextGuardianOnboardingTapped(OnNextGuardianOnboardingTapped event, Emitter<GuardiansState> emit) {
    final int index = state.indexDialog + 1;
    emit(OnboardingDialogsStateMapper().mapResultToState(state, index));
  }

  void _onPreviousGuardianOnboardingTapped(OnPreviousGuardianOnboardingTapped event, Emitter<GuardiansState> emit) {
    final int index = state.indexDialog - 1;
    emit(OnboardingDialogsStateMapper().mapResultToState(state, index));
  }

  void _onGuardianReadyForActivation(OnGuardianReadyForActivation event, Emitter<GuardiansState> emit) {
    emit(ActivateGuardianStateMapper().mapResultToState(state, event.myGuardians));
  }

  GuardiansState myGuardianCase(GuardianModel guardian) {
    if (guardian.status == GuardianStatus.alreadyGuardian) {
      if (guardian.recoveryStartedDate != null) {
        return state.copyWith(pageCommand: ShowRecoveryStarted(guardian));
      } else {
        return state.copyWith(pageCommand: ShowRemoveGuardianView(guardian));
      }
    } else {
      // Nothing to do here. Actions are handled by other events.
      return state;
    }
  }
}
