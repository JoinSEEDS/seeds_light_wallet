import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/profile_screens/guardians/guardians.i18n.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_bloc.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/page_commands.dart';

class OnboardingDialogsStateMapper extends StateMapper {
  GuardiansState mapResultToState(GuardiansState currentState, int index) {
    late PageCommand pageCommand;

    switch (index) {
      case 1:
        pageCommand = ShowOnboardingGuardianSingleAction(
            buttonTitle: "Next".i18n,
            index: index,
            image: "assets/images/guardians/onboarding/onboarding_1.jpg",
            description: "Welcome to the \n Key Guardians feature.".i18n);
        break;
      case 2:
        pageCommand = ShowOnboardingGuardianDoubleAction(
            rightButtonTitle: "Next".i18n,
            leftButtonTitle: "Previous".i18n,
            index: index,
            image: "assets/images/guardians/onboarding/onboarding_2.jpg",
            description: "Here, you can invite 3 - 5 individuals to help you secure your SEEDS account.".i18n);
        break;
      case 3:
        pageCommand = ShowOnboardingGuardianDoubleAction(
          rightButtonTitle: "Next".i18n,
          leftButtonTitle: "Previous".i18n,
          index: index,
          image: "assets/images/guardians/onboarding/onboarding_3.jpg",
          description:
              "If you ever lose your phone, forget your password or keyphrase, your Key Guardians will help you recover your account."
                  .i18n,
        );
        break;

      case 4:
        pageCommand = ShowOnboardingGuardianDoubleAction(
            rightButtonTitle: "Done".i18n,
            leftButtonTitle: "Previous".i18n,
            index: index,
            image: "assets/images/guardians/onboarding/onboarding_4.jpg",
            description:
                "Make sure to choose your guardians carefully and give them a heads up. The safety of your account may depend on them in the future!"
                    .i18n);
        break;
    }

    return currentState.copyWith(pageState: PageState.success, pageCommand: pageCommand, indexDialog: index);
  }
}
