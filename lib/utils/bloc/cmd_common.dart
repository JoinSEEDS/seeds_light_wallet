

/*

  Common commands and related command classes for use with Blocs

*/

abstract class Cmd {}

class UnknownCmd {

  final String? msg;
  final Cmd cmd;

  UnknownCmd(this.cmd, { this.msg });

  @override
  String toString() {
    String text = msg == null ? "" : ", msg: $msg";
    return 'UnknownCmd{${cmd.runtimeType}$text}';
  }

}