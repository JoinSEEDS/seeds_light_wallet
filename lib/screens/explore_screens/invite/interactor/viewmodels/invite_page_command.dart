import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/screens/explore_screens/invite/invite_errors.dart';

class ShowErrorMessage extends PageCommand {
  final InviteError message;

  ShowErrorMessage(this.message);
}

class ShowInviteLinkView extends PageCommand {}
