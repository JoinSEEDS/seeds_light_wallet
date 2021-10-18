import 'package:async/async.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/key_accounts_repository.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';

class ImportAccountsUseCase {
  final KeyAccountsRepository _keyAccountsRepository = KeyAccountsRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run(List<String> publicKeys) async {
    final List<Future<Result>> getKeyAccounts =
        publicKeys.map((i) => _keyAccountsRepository.getKeyAccounts(i)).toList();

    final List<Result> keyAccountsResponse = await Future.wait(getKeyAccounts);
    if (keyAccountsResponse.singleWhereOrNull((i) => i.isError) != null) {
      return keyAccountsResponse;
    } else {
      final List<List<String>> keyAccountsValues =
          keyAccountsResponse.map<List<String>>((i) => i.asValue!.value).toList();
      final List<String> keyAccounts = keyAccountsValues.expand((i) => i).toList();
      final List<String> savedAccounts = settingsStorage.accountsList;
      // Remove duplicated accounts
      savedAccounts.removeWhere((i) => keyAccounts.contains(i));
      final List<String> accounts = keyAccounts + savedAccounts;

      final List<Future<Result>> futures = accounts.map((i) => _profileRepository.getProfile(i)).toList();

      return Future.wait(futures);
    }
  }
}
