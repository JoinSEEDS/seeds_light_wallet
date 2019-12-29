import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:seeds/services/auth_service.dart';

class LinksService {
  final AuthService authService = AuthService();

  Future<Map<String, String>> parseInviteLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Map<String, String> queryParams =
          Uri.splitQueryString(deepLink.toString());

      if (queryParams["inviterAccount"] != null &&
          queryParams["inviteSecret"] != null) {
        return queryParams;
      }
    }

    Completer completer = new Completer();

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          if (deepLink != null) {
            Map<String, String> queryParams =
                Uri.splitQueryString(deepLink.toString());

            if (queryParams["inviterAccount"] != null &&
                queryParams["inviteSecret"] != null) {
              completer.complete(queryParams);
            }
          }
        },
        onError: (OnLinkErrorException e) async {});

    return completer.future;
  }

  Future<Uri> createInviteLink(String inviteSecret) async {
    String inviterAccount = await authService.getAccountName();

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://seedswallet.page.link',
      link: Uri.parse(
          'https://joinseeds.com/?placeholder=&inviterAccount=$inviterAccount&inviteSecret=$inviteSecret'),
    );

    final Uri dynamicUrl = await parameters.buildUrl();

    return dynamicUrl;
  }
}
