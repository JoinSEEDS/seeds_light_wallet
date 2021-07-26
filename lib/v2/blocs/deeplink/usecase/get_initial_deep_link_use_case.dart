import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:seeds/features/scanner/telos_signing_manager.dart';
import 'package:seeds/v2/blocs/deeplink/model/deep_link_data.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';

class GetInitialDeepLinkUseCase {
  Future<Result> run(Uri newLink) async {
    var splitUri = newLink.query.split('=');
    var placeHolder = splitUri[0];
    var linkData = splitUri[1];

    var deepLinkPlaceHolder = DeepLinkPlaceHolder.LINK_UNKNOWN;
    if (placeHolder.contains("guardian")) {
      SeedsESR request = SeedsESR(uri: linkData);

      await request.resolve(account: settingsStorage.accountName);
      var action = request.actions.first;
      var data = Map<String, dynamic>.from(action.data as Map<dynamic, dynamic>);
      data.addAll({"guardian_account": action.account});

      deepLinkPlaceHolder = DeepLinkPlaceHolder.LINK_GUARDIANS;
      return ValueResult(DeepLinkData(data, deepLinkPlaceHolder));
    } else if (placeHolder.contains("invite")) {
      deepLinkPlaceHolder = DeepLinkPlaceHolder.LINK_INVITE;
      return ValueResult(DeepLinkData(
        {"Mnemonic": linkData},
        deepLinkPlaceHolder,
      ));
    } else {
      deepLinkPlaceHolder = DeepLinkPlaceHolder.LINK_UNKNOWN;
      return ValueResult(DeepLinkData(
        {},
        deepLinkPlaceHolder,
      ));
    }
  }
}
