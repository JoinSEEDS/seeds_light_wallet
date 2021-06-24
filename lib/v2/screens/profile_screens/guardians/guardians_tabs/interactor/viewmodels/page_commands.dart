import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';

class ShowRemoveGuardianView extends PageCommand {
  final GuardianModel guardian;

  ShowRemoveGuardianView(this.guardian);
}

class ShowRecoveryStarted extends PageCommand {
  final GuardianModel guardian;

  ShowRecoveryStarted(this.guardian);
}

class ShowOnboardingGuardianSingleAction extends PageCommand {
  final int index;
  final String image;
  final String description;
  final String buttonTitle;

  ShowOnboardingGuardianSingleAction({
    required this.index,
    required this.description,
    required this.image,
    required this.buttonTitle,
  });
}

class ShowOnboardingGuardianDoubleAction extends PageCommand {
  final int index;
  final String image;
  final String description;
  final String leftButtonTitle;
  final String rightButtonTitle;

  ShowOnboardingGuardianDoubleAction({
    required this.index,
    required this.description,
    required this.image,
    required this.leftButtonTitle,
    required this.rightButtonTitle,
  });
}

class ShowActivateGuardian extends PageCommand {
  final int index;
  final String image;
  final String description;
  final String leftButtonTitle;
  final String rightButtonTitle;
  final Iterable<GuardianModel> myGuardians;

  ShowActivateGuardian({
    required this.index,
    required this.description,
    required this.image,
    required this.leftButtonTitle,
    required this.rightButtonTitle,
    required this.myGuardians,
  });
}
