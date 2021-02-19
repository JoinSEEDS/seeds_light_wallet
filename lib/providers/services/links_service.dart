import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:uni_links/uni_links.dart';

class LinksService {
  String inviterAccount;
  bool _enableMockLink = false;

  void update({String accountName, bool enableMockLink}) {
    inviterAccount = accountName;
    _enableMockLink = enableMockLink;
  }

  Future<void> listenSigningRequests(Function callback) async {
    try {
      final initialLink = await getInitialLink();

      callback(initialLink);
    } catch (err) {}

    getLinksStream().listen(callback);
  }

  Future<dynamic> processInitialLink() async {
    await Future.delayed(Duration(seconds: 1));
    if (_enableMockLink) {
      return {'inviteMnemonic': 'first-second-third-fourth-fifth'};
    }

    final data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    final deepLink = data?.link;
    if (deepLink != null) {
      final queryParams = deepLink.queryParameters;
      if (queryParams['inviteMnemonic'] != null) {
        return queryParams;
      }
    }

    return null;
  }

  void onDynamicLink(Function callback) {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData data) async {
      final deepLink = data?.link;

      var queryParams =
          Uri.splitQueryString(deepLink.toString());

      if (queryParams['inviteMnemonic'] != null) {
        callback(queryParams);
      }
    });
  }

  Future<Uri> createInviteLink(String inviteMnemonic) async {
    final parameters = DynamicLinkParameters(
      uriPrefix: 'https://seedswallet.page.link',
      link: Uri.parse(
        'https://joinseeds.com/?placeholder=&inviteMnemonic=$inviteMnemonic',
      ),
      androidParameters: AndroidParameters(
        packageName: 'com.joinseeds.seedswallet',
      ),
      iosParameters: IosParameters(
        bundleId: 'com.joinseeds.seedslight',
        appStoreId: '1507143650',
      ),
    );

    final dynamicUrl = (await parameters.buildShortLink()).shortUrl;

    return dynamicUrl;
  }

  Future<PendingDynamicLinkData> unpackDynamicLink(String link) => FirebaseDynamicLinks.instance
      .getDynamicLink(Uri.parse(link))
      .then((PendingDynamicLinkData dynamicLink) => dynamicLink);
}
