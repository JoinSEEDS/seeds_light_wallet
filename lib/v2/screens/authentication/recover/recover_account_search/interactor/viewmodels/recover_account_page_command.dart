import 'package:seeds/v2/domain-shared/page_command.dart';

class NavigateToRecoverAccountFound extends PageCommand {
  final String userAccount;

  NavigateToRecoverAccountFound(this.userAccount);
}