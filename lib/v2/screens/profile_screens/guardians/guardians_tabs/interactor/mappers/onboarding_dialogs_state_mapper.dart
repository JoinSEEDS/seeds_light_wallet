import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_state.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/page_commands.dart';

class OnboardingDialogsStateMapper extends StateMapper {
  GuardiansState mapResultToState(GuardiansState currentState, int index) {
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

    return currentState.copyWith(
      pageState: PageState.success,
      pageCommand: pageCommand,
      indexDialog: index
    );
  }
}
