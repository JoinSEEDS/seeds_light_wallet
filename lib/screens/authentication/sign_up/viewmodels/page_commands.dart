import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

class OnAccountNameGenerated extends PageCommand {}

class StartScan extends PageCommand {}

class OnAccountCreated extends PageCommand {
  final AuthDataModel authData;
  OnAccountCreated(this.authData);
}

class ReturnToLogin extends PageCommand {}
