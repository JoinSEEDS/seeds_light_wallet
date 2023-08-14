import 'package:async/async.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:seeds/domain-shared/app_constants.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class FirebaseDynamicLinkService {
  Future<Result<Uri>> createDynamicLink(String targetLink, String link) async {
    try {
      final parameters = DynamicLinkParameters(
        uriPrefix: domainAppUriPrefix,
        link: Uri.parse('$targetLink$link'),
        androidParameters: const AndroidParameters(packageName: androidPacakageName),
        iosParameters: const IOSParameters(bundleId: iosBundleId, appStoreId: iosAppStoreId),
      );
      final dynamicUrl = (await FirebaseDynamicLinks.instance.buildShortLink(parameters)).shortUrl;

      return Result.value(dynamicUrl);
    } catch (error) {
      print("Error creating dynamic link $error");
      return Result.error(error);
    }
  }
}
