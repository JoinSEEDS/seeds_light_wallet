import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/members_repository.dart';
import 'package:seeds/datasource/remote/api/vouch_repository.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/vouch_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class LoadVouchedListUseCase extends NoInputUseCase<List<ProfileModel>> {
  final VouchRepository _vouchRepository = VouchRepository();
  final MembersRepository _membersRepository = MembersRepository();

  @override
  Future<Result<List<ProfileModel>>> run() async {
    final account = settingsStorage.accountName;

    final result = await _vouchRepository.getVouchees(account);

    if (result.isError) {
      return Result.error(result.asError!.error);
    } else {
      final List<VouchModel> vouchedList = result.asValue!.value;
      final List<Future<Result<ProfileModel?>>> futures =
          vouchedList.map((e) => _membersRepository.getMemberByAccountName(e.account)).toList();

      final List<Result<ProfileModel?>> futureMembersModel = await Future.wait(futures);

      futureMembersModel.removeWhere((element) => element.isError);

      final List<ProfileModel> vouchedListAsMember =
          futureMembersModel.map((Result<ProfileModel?> i) => i.asValue!.value).whereType<ProfileModel>().toList();

      return Result.value(vouchedListAsMember);
    }
  }
}

