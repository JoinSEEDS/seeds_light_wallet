import 'package:seeds/datasource/local/cache_repository.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/local/web_view_cache_service.dart';
import 'package:seeds/domain-shared/shared_use_cases/account_use_case.dart';

class RemoveAccountUseCase extends AccountUseCase {
  Future<void> run() async {
    final String oldAccountName = settingsStorage.accountName;
    await settingsStorage.removeAccount();
    await const CacheRepository().clear();
    await const WebViewCacheService().clearCache();
    //ignore: unawaited_futures
    updateFirebaseToken(oldAccount: oldAccountName);
  }
}
