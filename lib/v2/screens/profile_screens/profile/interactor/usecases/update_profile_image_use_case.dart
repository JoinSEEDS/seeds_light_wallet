import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';

class UpdateProfileImageUseCase {
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<Result> run({required String imageUrl, required ProfileModel profile}) {
    return _profileRepository.updateProfile(
      accountName: settingsStorage.accountName,
      nickname: profile.nickname ?? '',
      image: imageUrl,
      story: profile.story ?? '',
      roles: profile.roles ?? '',
      skills: profile.skills ?? '',
      interests: profile.interests ?? '',
    );
  }
}
