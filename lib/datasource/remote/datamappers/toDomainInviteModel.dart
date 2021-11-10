import 'package:seeds/datasource/remote/model/invite_model.dart';

List<InviteModel> toDomainInviteModel(dynamic body) {
  final List invites = body['rows'].toList();
  return invites.map((item) => InviteModel.fromJson(item)).toList();
}
