import 'package:seeds/v2/domain-shared/page_command.dart';

class NavigateToGuardians extends PageCommand {}

class ShowErrorMessage extends PageCommand {
  final String errorMessage;

  ShowErrorMessage(this.errorMessage);
}
