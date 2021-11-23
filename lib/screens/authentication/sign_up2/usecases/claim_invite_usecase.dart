import 'package:async/async.dart';
import 'package:seeds/datasource/remote/api/signup_repository.dart';
import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';

class ClaimInviteUseCase {
  final SignupRepository _signupRepository = SignupRepository();

  Future<Result> validateInviteCode(String inviteCode) {
    final String inviteSecret = secretFromMnemonic(inviteCode);
    final String inviteHash = hashFromSecret(inviteSecret);
    return _signupRepository.findInvite(inviteHash);
  }

  Future<Result> unpackLink(String link) => _signupRepository.unpackDynamicLink(link);
}
