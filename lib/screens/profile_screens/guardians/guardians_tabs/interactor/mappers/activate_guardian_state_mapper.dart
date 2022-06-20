import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_bloc.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/page_commands.dart';

class ActivateGuardianStateMapper extends StateMapper {
  GuardiansState mapResultToState(GuardiansState currentState, Iterable<GuardianModel> myGuardians) {
    final pageCommand = ShowActivateGuardian(
        myGuardians: myGuardians,
        rightButtonTitle: "Activate".i18n,
        leftButtonTitle: "Dismiss".i18n,
        index: 4,
        image: "assets/images/guardians/onboarding/onboarding_1.jpg",
        description:
            "At least three of your nominated Key Guardians have accepted your request. All that is left is to activate them, and they will be able to help you recover your account when you need."
                .i18n);

    return currentState.copyWith(
      pageState: PageState.success,
      pageCommand: pageCommand,
    );
  }
}
