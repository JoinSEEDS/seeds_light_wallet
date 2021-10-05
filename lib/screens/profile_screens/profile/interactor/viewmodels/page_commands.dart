import 'package:seeds/domain-shared/page_command.dart';

class ShowLogoutDialog extends PageCommand {}

class ShowLogoutRecoveryPhraseDialog extends PageCommand {}

class ShowCitizenshipUpgradeSuccess extends PageCommand {
  final bool isResident;

  ShowCitizenshipUpgradeSuccess(this.isResident);
}

class ShowProcessingCitizenshipUpgrade extends PageCommand {}

class ShowSwitchAccount extends PageCommand {}
