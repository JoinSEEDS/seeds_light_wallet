import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GetSupportDataUseCase {
  Future<SupportDto> run() async {
    final String fid = await FirebaseInstallations.instance.getId();
    final info = await PackageInfo.fromPlatform();

    return SupportDto(fid, info);
  }
}

class SupportDto {
  final String firebaseInstallationId;
  final PackageInfo appInfo;

  SupportDto(this.firebaseInstallationId, this.appInfo);
}
