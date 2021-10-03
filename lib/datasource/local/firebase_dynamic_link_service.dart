import 'package:async/async.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:seeds/domain-shared/app_constants.dart';

class FirebaseDynamicLinkService {
  Future<Result> createDynamicLink(String targetLink, String link) async {
    final parameters = DynamicLinkParameters(
      uriPrefix: domainAppUriPrefix,
      link: Uri.parse('$targetLink$link'),
      androidParameters: AndroidParameters(packageName: androidPacakageName),
      iosParameters: IosParameters(bundleId: iosBundleId, appStoreId: iosAppStoreId),
    );

    final Uri dynamicUrl = (await parameters.buildShortLink()).shortUrl;

    return ValueResult(dynamicUrl);
  }
}
