import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/flag_repository.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/model/flag_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetFlaggedUsersUseCase extends NoInputUseCase<List<ProfileModel>> {
  final FlagRepository _flagRepository = FlagRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  Future<Result<List<ProfileModel>>> run() async {
    final account = settingsStorage.accountName;
    final Result<List<FlagModel>> flaggedUsersResult = await _flagRepository.getFlagsFrom(account);
    if (flaggedUsersResult.isValue) {
      final List<FlagModel> flaggedUsers = flaggedUsersResult.asValue!.value;

      final Iterable<Future<Result<ProfileModel>>> futures =
          flaggedUsers.map((e) => _profileRepository.getProfile(e.to));

      final List<Result> accounts = await Future.wait(futures);
      final List<ProfileModel> profiles =
          accounts.map((e) => e.isValue ? e.asValue?.value : null).whereType<ProfileModel>().toList();

      return Result.value(profiles);
    } else {
      return Result.error("Error fetching Flagged Users");
    }
  }
}
