import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';
import 'package:seeds/v2/datasource/remote/api/key_accounts_repository.dart';
import 'package:seeds/v2/datasource/remote/api/planted_repository.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/api/voice_repository.dart';

export 'package:async/src/result/result.dart';

class ImportKeyUseCase {
  final KeyAccountsRepository _keyAccountsRepository = KeyAccountsRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run(String publicKey) async {
    var accountsResponse = await _keyAccountsRepository.getKeyAccountsMongo(publicKey);
    if (accountsResponse.isError) {
      List<Result> items = [accountsResponse];
      return items;
    } else {
      List<String> accounts = accountsResponse.asValue!.value;

      List<Future<Result>> futures = accounts.map((String account) => _profileRepository.getProfile(account)).toList();

      return Future.wait(futures);
    }
  }
}
