import 'package:seeds/v2/domain-shared/page_command.dart';

class ShowStopGuardianRecoveryFailed extends PageCommand {
  final String message;

  ShowStopGuardianRecoveryFailed(this.message);
}

class ShowStopGuardianRecoverySuccess extends PageCommand {
  final String message;

  ShowStopGuardianRecoverySuccess(this.message);
}

class BottomBarNavigateToIndex extends PageCommand {
  final int index;

  BottomBarNavigateToIndex(this.index);
}
