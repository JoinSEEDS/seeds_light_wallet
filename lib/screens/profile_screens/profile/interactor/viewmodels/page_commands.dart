import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

class ShowLogoutDialog extends PageCommand {}

class ShowLogoutRecoveryPhraseDialog extends PageCommand {}

class ShowCitizenshipUpgradeSuccess extends PageCommand {
  final ProfileStatus status;

  ShowCitizenshipUpgradeSuccess(this.status);
}

class ShowProcessingCitizenshipUpgrade extends PageCommand {}

class ShowSwitchAccount extends PageCommand {}
