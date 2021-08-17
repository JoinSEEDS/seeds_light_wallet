import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:seeds/v2/blocs/deeplink/model/deep_link_data.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/local/util/seeds_esr.dart';

class GetInitialDeepLinkUseCase {
  Future<Result> run(Uri newLink) async {
    final splitUri = newLink.query.split('=');
    final placeHolder = splitUri[0];
    final linkData = splitUri[1];

    var deepLinkPlaceHolder = DeepLinkPlaceHolder.LINK_UNKNOWN;
    if (placeHolder.contains("guardian")) {
      final SeedsESR request = SeedsESR(uri: linkData);

      await request.resolve(account: settingsStorage.accountName);
      final action = request.actions.first;
      final data = Map<String, dynamic>.from(action.data as Map<dynamic, dynamic>);

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
