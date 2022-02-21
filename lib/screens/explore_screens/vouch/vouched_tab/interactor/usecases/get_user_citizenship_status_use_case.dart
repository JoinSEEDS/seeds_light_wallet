import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class GetUserCitizenshipStatusUseCase extends NoInputUseCase<ProfileModel> {
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  Future<Result<ProfileModel>> run() async {
    final result = await _profileRepository.getProfile(settingsStorage.accountName);

    if (result.isError) {
      return Result.error(result.asError!.error);
    } else {
      final ProfileModel profile = result.asValue!.value;

      return Result.value(profile);
    }
  }
}
