import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/model/referred_accounts_model.dart';

class GetReferredAccountsUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run() async {
    final Result<ReferredAccounts> result = await _profileRepository.getReferredAccounts(settingsStorage.accountName);
    if (result.isError) {
      return [result];
    } else {
      final ReferredAccounts referredAccounts = result.asValue!.value;
      //This is an expensive approach we need change it
      return Future.wait([for (final i in referredAccounts.accounts) _profileRepository.getProfile(i)]);
    }
  }
}
