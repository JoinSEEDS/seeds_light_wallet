import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/invite_repository.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';
import 'package:seeds/v2/domain-shared/shared_use_cases/cerate_firebase_dynamic_link_use_case.dart';
import 'package:seeds/v2/utils/mnemonic_code/mnemonic_code.dart';

class CreateInviteUseCase {
  final InviteRepository _inviteRepository = InviteRepository();
  final CreateFirebaseDynamicLinkUseCase _firebaseDynamicLinkUseCase = CreateFirebaseDynamicLinkUseCase();

  Future<List<Result>> run({required double amount, required String mnemonic}) {
    final String secret = secretFromMnemonic(mnemonic);
    final String hash = hashFromSecret(secret);

    final futures = [
      _inviteRepository.createInvite(
        quantity: amount,
        inviteHash: hash,
        accountName: settingsStorage.accountName,
      ),
      _firebaseDynamicLinkUseCase.createDynamicLink(target_link, mnemonic),
    ];
    return Future.wait(futures);
  }
}
