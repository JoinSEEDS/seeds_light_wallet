import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';

class GetUserAccountUseCase {
  Future<Result> run() => ProfileRepository().getProfile(settingsStorage.accountName);
}
