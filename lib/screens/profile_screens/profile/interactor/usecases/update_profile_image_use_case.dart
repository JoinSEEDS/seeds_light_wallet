import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class UpdateProfileImageUseCase extends InputUseCase<TransactionResponse, _Input> {
  final ProfileRepository _profileRepository = ProfileRepository();

  static _Input input({required String imageUrl, required ProfileModel profile}) =>
      _Input(imageUrl: imageUrl, profile: profile);

  @override
  Future<Result<TransactionResponse>> run(_Input input) {
    return _profileRepository.updateProfile(
      accountName: settingsStorage.accountName,
      nickname: input.profile.nickname,
      image: input.imageUrl,
      story: input.profile.story,
      roles: input.profile.roles,
      skills: input.profile.skills,
      interests: input.profile.interests,
    );
  }
}

class _Input {
  final String imageUrl;
  final ProfileModel profile;

  _Input({required this.imageUrl, required this.profile});
}
