import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_state.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/page_commands.dart';

class ActivateGuardianStateMapper extends StateMapper {
  GuardiansState mapResultToState(GuardiansState currentState, Iterable<GuardianModel> myGuardians) {
    final pageCommand = ShowActivateGuardian(
        myGuardians: myGuardians,
        rightButtonTitle: "Activate Guardians!",
        leftButtonTitle: "Dismiss",
        index: 4,
        image: "assets/images/guardians/onboarding/onboarding_1.jpg",
        description:
            "At least three of your nominated Key Guardians have accepted your request. All that is left is to activate them"
            " and they will be able to help you recover your account when you need.");

    return currentState.copyWith(
      pageState: PageState.success,
      pageCommand: pageCommand,
    );
  }
}
