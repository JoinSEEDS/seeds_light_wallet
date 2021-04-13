// @dart=2.9


import 'package:permission_handler/permission_handler.dart';

class PermissionService {

  Future<PermissionStatus> camera(bool query) {
    if(query) {
      return Permission.camera.status;
    } else {
      return Permission.camera.request();
    }
  }

  Future<bool> openSettings() => openAppSettings();

}