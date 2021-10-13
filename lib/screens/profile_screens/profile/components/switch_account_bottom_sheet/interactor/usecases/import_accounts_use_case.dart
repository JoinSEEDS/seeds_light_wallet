import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/key_accounts_repository.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';

class ImportAccountsUseCase {
  final KeyAccountsRepository _keyAccountsRepository = KeyAccountsRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run(String publicKey) async {
    final accountsResponse = await _keyAccountsRepository.getKeyAccounts(publicKey);
    if (accountsResponse.isError) {
      final List<Result> items = [accountsResponse];
      return items;
    } else {
      final List<String> currentKeyAccounts = accountsResponse.asValue!.value;
      final List<String> savedAccounts = settingsStorage.accountsList;
      // Remove duplicated accounts
      savedAccounts.removeWhere((i) => currentKeyAccounts.contains(i));
      final List<String> accounts = currentKeyAccounts + savedAccounts;

      final List<Future<Result>> futures = accounts.map((account) => _profileRepository.getProfile(account)).toList();

      return Future.wait(futures);
    }
  }
}
