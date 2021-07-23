// ignore: import_of_legacy_library_into_null_safe
import 'package:dart_esr/dart_esr.dart';
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

class ProcessSigningRequest extends PageCommand {
  final Action action;

  ProcessSigningRequest(this.action);
}

class ShowApproveGuardianRecoverySuccess extends PageCommand {
  final String message;

  ShowApproveGuardianRecoverySuccess(this.message);
}
