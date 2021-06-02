import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';

class NavigateToSelectGuardians extends PageCommand {
  final List<GuardianModel> myGuardians;

  NavigateToSelectGuardians(this.myGuardians);
}

class ShowMessage extends PageCommand {
  final String message;

  ShowMessage(this.message);
}