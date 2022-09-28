import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';

class GetPublicKeysFromAccountUseCase {
  Future<Result> run(String account) => ProfileRepository().getAccountPublicKeys(account);
}
