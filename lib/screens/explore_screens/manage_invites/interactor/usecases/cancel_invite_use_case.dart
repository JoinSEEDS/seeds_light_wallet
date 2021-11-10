import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/invite_repository.dart';

class CancelInviteUseCase {
  final InviteRepository _inviteRepository = InviteRepository();

  Future<Result> run(String inviteHash) async {
    final account = settingsStorage.accountName;

    return _inviteRepository.cancelInvite(inviteHash: inviteHash, accountName: account);
  }
}
