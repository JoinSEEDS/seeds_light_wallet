import 'package:seeds/domain-shared/page_command.dart';

class ShowMaxUserCountSelected extends PageCommand {
  final String message;

  ShowMaxUserCountSelected(this.message);
}
