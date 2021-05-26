import 'package:seeds/v2/domain-shared/page_command.dart';

class SendTextInputDataBack extends PageCommand {
  final String textToSend;

  SendTextInputDataBack(this.textToSend);
}
