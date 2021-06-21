import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/mappers/init_guardians_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/mappers/remove_guardian_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/get_guardians_usecase.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/init_guardians_usecase.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/remove_guardian_usecase.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_events.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_state.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/page_commands.dart';

/// --- BLOC
class GuardiansBloc extends Bloc<GuardiansEvent, GuardiansState> {
  GuardiansBloc() : super(GuardiansState.initial());

  final GetGuardiansUseCase _userCase = GetGuardiansUseCase();
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();

  Stream<List<GuardianModel>> get guardians {
    return _userCase.getGuardians();
  }

  Stream<bool> get isGuardianContractInitialized {
    return _repository.isGuardiansInitialized(settingsStorage.accountName);
  }

  @override
  Stream<GuardiansState> mapEventToState(GuardiansEvent event) async* {
    if (event is InitGuardians) {
      if (event.myGuardians.length < 3) {
        yield state.copyWith(pageCommand: ShowMessage("Minimum 3 guardians needed"));
      } else {
        yield state.copyWith(pageState: PageState.loading);

        var result = await InitGuardiansUseCase().initGuardians(event.myGuardians);

        yield InitGuardiansStateMapper().mapResultToState(state, result);
      }
    } else if (event is ClearPageCommand) {
      yield state.copyWith(pageCommand: null);
    } else if (event is OnAddGuardiansTapped) {
      List<GuardianModel> results = await guardians.first;
      results.retainWhere((element) => element.type == GuardianType.myGuardian);

      yield state.copyWith(
          pageCommand: NavigateToRouteWithArguments(
        route: Routes.selectGuardians,
        arguments: results,
      ));
    } else if (event is OnAcceptGuardianTapped) {
      await _repository.acceptGuardianRequestedMe(
          currentUserId: settingsStorage.accountName, friendId: event.guardianAccount);
    } else if (event is OnCancelGuardianRequestTapped) {
      await _repository.cancelGuardianRequest(
          currentUserId: settingsStorage.accountName, friendId: event.guardianAccount);
    } else if (event is OnDeclineGuardianTapped) {
      await _repository.declineGuardianRequestedMe(
          currentUserId: settingsStorage.accountName, friendId: event.guardianAccount);
    } else if (event is OnGuardianRowTapped) {
      switch (event.guardian.type) {
        case GuardianType.myGuardian:
          yield myGuardianCase(event.guardian);
          break;
        case GuardianType.imGuardian:
          // Nothing to do here.
          yield state;
          break;
      }
    } else if (event is OnStopRecoveryForUser) {
      await _repository.stopRecoveryForUser(settingsStorage.accountName);
    } else if (event is OnRemoveGuardianTapped) {
      yield state.copyWith(pageState: PageState.loading);
      var result = await RemoveGuardianUseCase().removeGuardian(event.guardian);
      yield RemoveGuardianStateMapper().mapResultToState(state, result);
    } else if (event is InitOnboardingGuardian) {
      yield state.copyWith(pageCommand: createPageCommand(1), indexDialog: 1);
    } else if (event is OnNextGuardianOnboardingTapped) {
      int index = state.indexDialog + 1;
      yield state.copyWith(pageCommand: createPageCommand(index), indexDialog: index);
    } else if (event is OnPreviousGuardianOnboardingTapped) {
      int index = state.indexDialog - 1;
      yield state.copyWith(pageCommand: createPageCommand(index), indexDialog: index);
    } else if (event is OnGuardianReadyForActivation) {
      yield state.copyWith(pageCommand: createActivateGuardianPageCommand(event.myGuardians));
    }
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

PageCommand createActivateGuardianPageCommand(Iterable<GuardianModel> myGuardians) {
  return ShowActivateGuardianDoubleAction(
      myGuardians: myGuardians,
      rightButtonTitle: "Activate Guardians!",
      leftButtonTitle: "Dismiss",
      index: 4,
      image: "assets/images/guardians/onboarding/onboarding_1.jpg",
      description:
          "At least three of your nominated Key Guardians have accepted your request. All that is left is to activate them"
          " and they will be able to help you recover your account when you need.");
}

PageCommand createPageCommand(int index) {
  late PageCommand pageCommand;

  switch (index) {
    case 1:
      pageCommand = ShowOnboardingGuardianSingleAction(
          buttonTitle: "Next",
          index: index,
          image: "assets/images/guardians/onboarding/onboarding_1.jpg",
          description: "Welcome to the \n Key Guardians feature.");
      break;
    case 2:
      pageCommand = ShowOnboardingGuardianDoubleAction(
          rightButtonTitle: "Next",
          leftButtonTitle: "Previous",
          index: index,
          image: "assets/images/guardians/onboarding/onboarding_2.jpg",
          description: "Here, you can invite 3 - 5 individuals to help you secure your SEEDS account.");
      break;
    case 3:
      pageCommand = ShowOnboardingGuardianDoubleAction(
        rightButtonTitle: "Next",
        leftButtonTitle: "Previous",
        index: index,
        image: "assets/images/guardians/onboarding/onboarding_3.jpg",
        description:
            "If you ever lose your phone, forget your password or keyphrase, your Key Guardians will help you recover your account.",
      );
      break;

    case 4:
      pageCommand = ShowOnboardingGuardianDoubleAction(
          rightButtonTitle: "Done",
          leftButtonTitle: "Previous",
          index: index,
          image: "assets/images/guardians/onboarding/onboarding_4.jpg",
          description:
              "Make sure to choose your guardians carefully and give them a heads up. The safety of your account may depend on them in the future!");
      break;
  }

  return pageCommand;
}
