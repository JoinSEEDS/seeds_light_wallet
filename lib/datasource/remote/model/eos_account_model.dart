import 'package:seeds/datasource/remote/model/eos_permissions_model.dart';

class EOSAccountModel {
  final EOSPermissionsModel permissions;
  const EOSAccountModel({required this.permissions});

  factory EOSAccountModel.fromJson(dynamic json) {
    return EOSAccountModel(permissions:
      EOSPermissionsModel.fromJson(json as Map<String, dynamic>)
     );
  }
}
