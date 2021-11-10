import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/invite_repository.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/model/invite_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';

class GetInvitesUseCase {
  final InviteRepository _inviteRepository = InviteRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<InvitesDto?> run() async {
    final account = settingsStorage.accountName;

    final Result<List<InviteModel>> result = await _inviteRepository.getInvites(account);

    if (result.isError) {
      return null;
    } else {
      final List<InviteModel> invites = result.asValue!.value;
      final Iterable<Future<Result>> futures = invites
          .where((element) => element.isClaimed && element.account != null)
          .map((e) => _profileRepository.getProfile(e.account!));

      final List<Result> accounts = await Future.wait(futures);
      final List<ProfileModel> profiles =
          accounts.map((e) => e.isValue ? e.asValue?.value as ProfileModel : null).whereType<ProfileModel>().toList();

      return InvitesDto(profiles, invites);
    }
  }
}

class InvitesDto {
  final List<ProfileModel> accounts;
  final List<InviteModel> invites;

  InvitesDto(this.accounts, this.invites);
}
