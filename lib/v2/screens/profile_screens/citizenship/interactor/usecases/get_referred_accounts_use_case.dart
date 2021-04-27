import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/model/referred_accounts_model.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';

class GetReferredAccountsUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<Result> run() async {
    var res = await _profileRepository.getReferredAccounts(settingsStorage.accountName);
    ReferredAccounts referredAccounts = res.asValue!.value as ReferredAccounts;
    var myList = referredAccounts.accounts.take(5);
    List<ProfileModel> accounts = [];
    for (var i in myList) {
      var res = await _profileRepository.getProfile(i);
      accounts.add(res.asValue?.value);
    }
    return ValueResult(accounts);
  }
}
