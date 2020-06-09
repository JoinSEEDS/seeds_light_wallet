import 'package:seeds/utils/bloc/cmd_common.dart';

abstract class AccountCmd extends Cmd {}

class UpdateSuggestionCmd extends AccountCmd {
  final String value;
  UpdateSuggestionCmd(this.value);
}
