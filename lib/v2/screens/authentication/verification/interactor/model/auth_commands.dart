import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/screens/authentication/verification/interactor/model/auth_type.dart';

class AuthenticateCmd extends PageCommand {
  final AuthType type;

  AuthenticateCmd(this.type);
}
