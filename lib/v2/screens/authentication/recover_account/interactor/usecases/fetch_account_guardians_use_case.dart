import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/balance_repository.dart';
import 'package:seeds/v2/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/api/key_accounts_repository.dart';
import 'package:seeds/v2/datasource/remote/api/planted_repository.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/api/voice_repository.dart';

class FetchAccountRecoveryUseCase {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  Future<Result> run(String accountName) {
    return _guardiansRepository.getAccountRecovery(accountName);
  }
}
