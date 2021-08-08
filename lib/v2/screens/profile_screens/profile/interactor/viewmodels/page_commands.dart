import 'package:seeds/v2/domain-shared/page_command.dart';

class ShowLogoutDialog extends PageCommand {}

class ShowCitizenshipUpgradeSuccess extends PageCommand {
  final bool isResident;

  ShowCitizenshipUpgradeSuccess(this.isResident);
}
