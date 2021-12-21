import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/signup_repository.dart';

class CheckAccountNameAvailabilityUseCase {
  Future<Result> run(String accountName) => SignupRepository().isUsernameTaken(accountName);
}
