import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/usecases/load_vouched_list_use_case.dart';

class GetVouchedInitialDataUseCase extends NoInputUseCase<VouchedDto> {
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  Future<Result<VouchedDto>> run() async {
    final Result<ProfileModel> userProfileResult = await _profileRepository.getProfile(settingsStorage.accountName);

    if (userProfileResult.isError) {
      return Result.error(userProfileResult.asError!.error);
    } else {
      final ProfileModel userProfile = userProfileResult.asValue!.value;

      if (userProfile.status == ProfileStatus.visitor) {
        return Result.value(VouchedDto(userProfile, []));
      } else {
        final Result<List<ProfileModel>> vouchedList = await LoadVouchedListUseCase().run();

        if (vouchedList.isError) {
          return Result.error(userProfileResult.asError!.error);
        } else {
          return Result.value(VouchedDto(userProfile, vouchedList.asValue!.value));
        }
      }
    }
  }
}

class VouchedDto {
  ProfileModel userProfile;
  List<ProfileModel> vouchedUsers;

  VouchedDto(this.userProfile, this.vouchedUsers);
}
