import 'package:seeds/v2/domain-shared/page_command.dart';

class NavigateToRecoverAccountFound extends PageCommand {
  final Input args;

  NavigateToRecoverAccountFound(this.args);
}

class Input {
  final List<String> guardians;
  final String userAccount;

  Input(this.guardians, this.userAccount);
}
