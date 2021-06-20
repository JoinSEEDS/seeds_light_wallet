import 'package:seeds/v2/utils/mnemonic_code/mnemonic_code.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/invite_repository.dart';

class CreateInviteUseCase {
  final InviteRepository _inviteRepository = InviteRepository();

  Future<List<Result>> run({required double amount, required String mnemonic}) {
    String secret = secretFromMnemonic(mnemonic);
    String hash = hashFromSecret(secret);

    var futures = [
      _inviteRepository.createInvite(
        quantity: amount,
        inviteHash: hash,
        accountName: settingsStorage.accountName,
      ),
      _inviteRepository.createInviteLink(mnemonic),
    ];
    return Future.wait(futures);
  }
}
