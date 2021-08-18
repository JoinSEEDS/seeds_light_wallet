import 'package:async/async.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:seeds/domain-shared/app_constants.dart';

class FirebaseDynamicLinkService {
  Future<Result> createDynamicLink(String targetLink, String link) async {
    final parameters = DynamicLinkParameters(
      uriPrefix: domain_app_uri_prefix,
      link: Uri.parse('$targetLink$link'),
      androidParameters: AndroidParameters(packageName: android_pacakage_name),
      iosParameters: IosParameters(bundleId: ios_bundle_id, appStoreId: ios_app_store_id),
    );

    final Uri dynamicUrl = (await parameters.buildShortLink()).shortUrl;

    return ValueResult(dynamicUrl);
  }
}
