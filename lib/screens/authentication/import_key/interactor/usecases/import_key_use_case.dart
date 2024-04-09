import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/key_accounts_repository.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';

class ImportKeyUseCase {
  final KeyAccountsRepository _keyAccountsRepository = KeyAccountsRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run(String publicKey) async {
    final accountsResponse = await _keyAccountsRepository.getKeyAccounts(publicKey);
    if (accountsResponse.isError) {
      final List<Result> items = [accountsResponse];
      return items;
    } else {
      final List<String> accounts = accountsResponse.asValue!.value as List<String>;

      final List<Future<Result>> futures =
          accounts.map((String account) => _profileRepository.getProfile(account)).toList();

      return Future.wait(futures);
    }
  }
}
