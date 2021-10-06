import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

class ShowDelegateConfirmation extends PageCommand {
  final MemberModel selectedDelegate;

  ShowDelegateConfirmation(this.selectedDelegate);
}
