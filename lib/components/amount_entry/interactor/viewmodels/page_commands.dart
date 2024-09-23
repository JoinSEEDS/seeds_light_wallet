import 'package:seeds/domain-shared/page_command.dart';

class SendTextInputDataBack extends PageCommand {
  final String textToSend;

  SendTextInputDataBack(this.textToSend);
}

class PushTextIntoField extends PageCommand {
  final String textToPush;

  PushTextIntoField(this.textToPush);
}