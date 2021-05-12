import 'package:async/async.dart';
import 'package:seeds/utils/invites.dart';
import 'package:seeds/v2/blocs/signup/mappers/claim_invite_mapper.dart';
import 'package:seeds/v2/blocs/signup/viewmodels/bloc.dart';
import 'package:seeds/v2/blocs/signup/viewmodels/signup_bloc.dart';
import 'package:seeds/v2/blocs/signup/viewmodels/states/claim_invite_state.dart';
import 'package:seeds/v2/datasource/remote/api/signup_repository.dart';

class ClaimInviteUseCase {
  ClaimInviteUseCase({required SignupRepository signupRepository})
      : _signupRepository = signupRepository;

  final SignupRepository _signupRepository;

  Stream<SignupState> validateInviteCode(
      SignupState currentState, String inviteCode) async* {
    final String inviteSecret = secretFromMnemonic(inviteCode);
    final String inviteHash = hashFromSecret(inviteSecret);

    yield currentState.copyWith(
        claimInviteState:
            ClaimInviteState.loading(currentState.claimInviteState));

    final Result invite = await _signupRepository.findInvite(inviteHash);

    yield ClaimInviteMapper()
        .mapValidateInviteCodeToState(currentState, invite);
  }

  Stream<SignupState> unpackLink(SignupState currentState, String link) async* {
    yield currentState.copyWith(
        claimInviteState:
            ClaimInviteState.loading(currentState.claimInviteState));

    final Result inviteMnemonic =
        await _signupRepository.unpackDynamicLink(link);

    yield ClaimInviteMapper()
        .mapInviteMnemonicToState(currentState, inviteMnemonic);
  }
}
