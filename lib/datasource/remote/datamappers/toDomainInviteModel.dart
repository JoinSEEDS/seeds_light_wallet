import 'package:seeds/datasource/remote/model/invite_model.dart';

List<InviteModel> toDomainInviteModel(Map<String, dynamic> body) {
  final List invites = body['rows'] as List;
  return invites.map((item) => InviteModel.fromJson(item as Map<String, dynamic>)).toList();
}
