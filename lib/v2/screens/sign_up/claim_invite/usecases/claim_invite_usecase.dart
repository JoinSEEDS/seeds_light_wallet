import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/api/signup_repository.dart';
import 'package:seeds/v2/screens/sign_up/claim_invite/mappers/claim_invite_mapper.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/states/claim_invite_state.dart';
import 'package:seeds/v2/utils/mnemonic_code/mnemonic_code.dart';

class ClaimInviteUseCase {
  ClaimInviteUseCase({required SignupRepository signupRepository}) : _signupRepository = signupRepository;

  final SignupRepository _signupRepository;

  Stream<SignupState> validateInviteCode(SignupState currentState, String inviteCode) async* {
    final String inviteSecret = secretFromMnemonic(inviteCode);
    final String inviteHash = hashFromSecret(inviteSecret);

    yield currentState.copyWith(claimInviteState: ClaimInviteState.loading(currentState.claimInviteState));

    final Result invite = await _signupRepository.findInvite(inviteHash);

    yield ClaimInviteMapper().mapValidateInviteCodeToState(currentState, invite);
  }

  Stream<SignupState> unpackLink(SignupState currentState, String link) async* {
    yield currentState.copyWith(claimInviteState: ClaimInviteState.loading(currentState.claimInviteState));

    final Result inviteMnemonic = await _signupRepository.unpackDynamicLink(link);

    yield ClaimInviteMapper().mapInviteMnemonicToState(currentState, inviteMnemonic);
  }

  SignupState navigateToDisplayName(SignupState currentState) {
    return currentState.copyWith(pageContent: PageContent.DISPLAY_NAME);
  }
}
