import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

class ShowDelegateConfirmation extends PageCommand {
  final ProfileModel selectedDelegate;

  ShowDelegateConfirmation(this.selectedDelegate);
}

class ShowDelegateUserSuccess extends PageCommand {}
