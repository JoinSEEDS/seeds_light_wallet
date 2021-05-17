import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/model/referred_accounts_model.dart';

class GetReferredAccountsUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run() async {
    var result = await _profileRepository.getReferredAccounts(settingsStorage.accountName);
    if (result.isError) {
      return [result];
    } else {
      ReferredAccounts referredAccounts = result.asValue?.value as ReferredAccounts;
      //This is an expensive approach we need change it
      return Future.wait([for (var i in referredAccounts.accounts) _profileRepository.getProfile(i)]);
    }
  }
}
