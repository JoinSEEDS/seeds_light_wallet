import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

/// SendEnterDataScreen SCREEN
class SendEnterDataArguments {
  final MemberModel member;
  final TokenModel token;
  SendEnterDataArguments(this.member, this.token);
}
