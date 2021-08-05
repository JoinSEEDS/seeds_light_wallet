// ignore: import_of_legacy_library_into_null_safe
import 'package:dart_esr/dart_esr.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';

class BottomBarNavigateToIndex extends PageCommand {
  final int index;

  BottomBarNavigateToIndex(this.index);
}

class ProcessSigningRequest extends PageCommand {
  final Action action;

  ProcessSigningRequest(this.action);
}
