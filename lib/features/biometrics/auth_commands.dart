

import 'package:seeds/features/biometrics/auth_type.dart';
import 'package:seeds/utils/bloc/cmd_common.dart';

abstract class AuthCmd extends Cmd {}

class InitAuthenticationCmd extends AuthCmd {}
class AuthenticateCmd extends AuthCmd {
  final AuthType type;
  AuthenticateCmd(this.type);
}
class ChangePreferredCmd extends AuthCmd {
  final AuthType type;
  ChangePreferredCmd(this.type);
}
class DisablePasswordCmd extends AuthCmd {}
