import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

class ShowVouchForMemberConfirmation extends PageCommand {
  final MemberModel selectedMember;

  ShowVouchForMemberConfirmation(this.selectedMember);
}

class ShowVouchForMemberSuccess extends PageCommand {}
