import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/screens/authentication/verification/interactor/model/auth_type.dart';

class AuthenticateCmd extends PageCommand {
  final AuthType type;

  AuthenticateCmd(this.type);
}
