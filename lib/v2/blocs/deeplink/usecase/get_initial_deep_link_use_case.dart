import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:seeds/features/scanner/telos_signing_manager.dart';
import 'package:seeds/v2/blocs/deeplink/model/deep_link_data.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';

class GetInitialDeepLinkUseCase {
  Future<Result> run(Uri newLink) async {
    var splitUri = newLink.query.split('=');
    var placeHolder = splitUri[0];
    var esrUrl = splitUri[1];

    SeedsESR request = SeedsESR(uri: esrUrl);

    await request.resolve(account: settingsStorage.accountName);
    var action = request.actions.first;
    var data = Map<String, dynamic>.from(action.data as Map<dynamic, dynamic>);

    var deepLinkPlaceHolder = DeepLinkPlaceHolder.LINK_UNKNOWN;
    if (placeHolder.contains("guardian")) {
      deepLinkPlaceHolder = DeepLinkPlaceHolder.LINK_GUARDIANS;
    } else if (placeHolder.contains("invite")) {
      deepLinkPlaceHolder = DeepLinkPlaceHolder.LINK_INVITE;
    } else {
      deepLinkPlaceHolder = DeepLinkPlaceHolder.LINK_UNKNOWN;
    }

    return ValueResult(DeepLinkData(
      data,
      deepLinkPlaceHolder,
      action.account,
    ));
  }
}
