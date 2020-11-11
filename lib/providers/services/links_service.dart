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
    if (_enableMockLink)
      return {"inviteMnemonic": "first-second-third-fourth-fifth"};

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    final Uri deepLink = data?.link;
    if (deepLink != null) {
      final queryParams = deepLink.queryParameters;
      if (queryParams["inviteMnemonic"] != null) {
        return queryParams;
      }
    }

    return null;
  }

  void onDynamicLink(Function callback) {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData data) async {
      final Uri deepLink = data?.link;

      Map<String, String> queryParams =
          Uri.splitQueryString(deepLink.toString());

      if (queryParams["inviteMnemonic"] != null) {
        callback(queryParams);
      }
    });
  }

  Future<Uri> createInviteLink(String inviteMnemonic) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://seedswallet.page.link',
      link: Uri.parse(
        'https://joinseeds.com/?placeholder=&inviteMnemonic=$inviteMnemonic',
      ),
      androidParameters: AndroidParameters(
        packageName: "com.joinseeds.seedswallet",
      ),
      iosParameters: IosParameters(
        bundleId: "com.joinseeds.seedslight",
        appStoreId: "1507143650",
      ),
    );

    final Uri dynamicUrl = (await parameters.buildShortLink()).shortUrl;

    return dynamicUrl;
  }

  Future<Uri> unpackDynamicLink(String link) => FirebaseDynamicLinks.instance
      .getDynamicLink(Uri.parse(link))
      .then((PendingDynamicLinkData dynamicLink) => dynamicLink.link);
}
