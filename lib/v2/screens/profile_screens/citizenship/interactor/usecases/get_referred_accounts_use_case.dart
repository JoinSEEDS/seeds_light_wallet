import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/model/referred_accounts_model.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';

class GetReferredAccountsUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<Result> run() async {
    return _profileRepository.getReferredAccounts(settingsStorage.accountName).then((Result result) async {
      if (result.isError) {
        return result;
      } else {
        ReferredAccounts referredAccounts = result.asValue?.value as ReferredAccounts;
        List<ProfileModel> accounts = [];
        //This is an expensive approach we need change it
        for (var i in referredAccounts.accounts) {
          var res = await _profileRepository.getProfile(i);
          accounts.add(res.asValue?.value);
        }
        return ValueResult(accounts);
      }
    }).catchError((error) {
      return ErrorResult("Error getting referreds accounts");
    });
  }
}
