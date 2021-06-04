import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';

class NavigateToSelectGuardians extends PageCommand {
  final List<GuardianModel> myGuardians;

  NavigateToSelectGuardians(this.myGuardians);
}

class ShowMessage extends PageCommand {
  final String message;

  ShowMessage(this.message);
}

class ShowRemoveGuardianView extends PageCommand {
  final GuardianModel guardian;

  ShowRemoveGuardianView(this.guardian);
}

class ShowRecoveryStarted extends PageCommand {
  final GuardianModel guardian;

  ShowRecoveryStarted(this.guardian);
}