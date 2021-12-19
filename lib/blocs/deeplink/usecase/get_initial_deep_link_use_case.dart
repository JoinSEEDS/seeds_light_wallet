import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:seeds/blocs/deeplink/model/deep_link_data.dart';
import 'package:seeds/blocs/deeplink/usecase/get_signing_request_use_case.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/local/util/seeds_esr.dart';

class GetInitialDeepLinkUseCase {
  GetSigningRequestUseCase getSigningRequestUseCase = GetSigningRequestUseCase();

  Future<DeepLinkData> run(Uri newLink) async {
    final splitUri = newLink.query.split('=');
    final placeHolder = splitUri[0];
    final linkData = splitUri[1];

    var deepLinkPlaceHolder = DeepLinkPlaceHolder.linkUnknown;
    if (placeHolder.contains("guardian")) {
      final SeedsESR request = SeedsESR(uri: linkData);

      await request.resolve(account: settingsStorage.accountName);
      final action = request.actions.first;
      final data = Map<String, dynamic>.from(action.data as Map<dynamic, dynamic>);

      deepLinkPlaceHolder = DeepLinkPlaceHolder.linkGuardians;
      return DeepLinkData(data, deepLinkPlaceHolder);
    } else if (placeHolder.contains("invite")) {
      deepLinkPlaceHolder = DeepLinkPlaceHolder.linkInvite;
      return DeepLinkData(
        {"Mnemonic": linkData},
        deepLinkPlaceHolder,
      );
    } else if (placeHolder.contains("invoice")) {
      deepLinkPlaceHolder = DeepLinkPlaceHolder.linkInvoice;
      final Future<Result> esrData = getSigningRequestUseCase.run(linkData);

      return DeepLinkData(
        {"invoice": esrData},
        deepLinkPlaceHolder,
      );
    } else {
      deepLinkPlaceHolder = DeepLinkPlaceHolder.linkUnknown;
      return DeepLinkData(
        {},
        deepLinkPlaceHolder,
      );
    }
  }
}
