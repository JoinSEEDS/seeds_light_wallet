import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/members_repository.dart';
import 'package:seeds/datasource/remote/api/vouch_repository.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/datasource/remote/model/vouch_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';

class LoadSponsorsUseCase extends NoInputUseCase<List<MemberModel>> {
  final VouchRepository _vouchRepository = VouchRepository();
  final MembersRepository _membersRepository = MembersRepository();

  @override
  Future<Result<List<MemberModel>>> run() async {
    final account = settingsStorage.accountName;

    final result = await _vouchRepository.getSponsors(account);

    if (result.isError) {
      return Result.error(result.asError!.error);
    } else {
      final List<VouchModel> sponsors = result.asValue!.value;
      final List<Future<Result<MemberModel?>>> futures =
          sponsors.map((e) => _membersRepository.getMemberByAccountName(e.sponsor)).toList();

      final List<Result<MemberModel?>> futureMembersModel = await Future.wait(futures);

      futureMembersModel.removeWhere((element) => element.isError);

      final List<MemberModel> sponsorsAsMember =
          futureMembersModel.map((Result<MemberModel?> i) => i.asValue!.value).whereType<MemberModel>().toList();

      return Result.value(sponsorsAsMember);
    }
  }
}

