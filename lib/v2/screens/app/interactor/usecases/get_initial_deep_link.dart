import 'package:async/async.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:seeds/features/scanner/telos_signing_manager.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:uni_links/uni_links.dart';

class GetInitialDeepLinkUseCase {
  Future<Result> run() {
    return getInitialLink()
        .then((link) => _getRequestData(link))
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((onError) => ErrorResult(onError));
  }

  Future<Result> _getRequestData(String? link) {
    if (link != null) {
      SeedsESR request = SeedsESR(uri: link);
      return request
          .resolve(account: settingsStorage.accountName)
          .then((value) => ValueResult(value))
          // ignore: return_of_invalid_type_from_catch_error
          .catchError((onError) => ErrorResult(onError));
    } else {
      return Future.value(ValueResult(null));
    }
  }
}
