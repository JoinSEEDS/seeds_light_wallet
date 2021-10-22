import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';

class GetPublicKeyFromAccountUseCase {
  Future<Result> run(String account) => ProfileRepository().getAccountPublicKey(account);
}
