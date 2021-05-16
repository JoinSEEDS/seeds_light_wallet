import 'package:seeds/i18n/claim_code.i18n.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/v2/blocs/signup/viewmodels/bloc.dart';
import 'package:seeds/v2/blocs/signup/viewmodels/states/claim_invite_state.dart';
import 'package:seeds/v2/datasource/remote/model/invite_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';

class ClaimInviteMapper extends StateMapper {
  SignupState mapValidateInviteCodeToState(SignupState currentState, Result result) {
    final claimInviteCurrentState = currentState.claimInviteState;

    if (result.isError) {
      return currentState.copyWith(
          claimInviteState: ClaimInviteState.error(claimInviteCurrentState, result.asError!.error.toString()));
    } else {
      final InviteModel inviteModel = result.asValue!.value;

      if (inviteModel.account.isNullOrEmpty) {
        // invite code is valid and can be claimed
        final newState = claimInviteCurrentState.copyWith(
          pageState: PageState.success,
          inviteModel: inviteModel,
        );

        return currentState.copyWith(claimInviteState: newState);
      } else {
        // invite code is valid but claimed before
        final newState = ClaimInviteState.error(claimInviteCurrentState,
            'Invite of %s was already claimed by %s'.i18n.fill(["${inviteModel.sponsor}", "${inviteModel.account}"]));
        return currentState.copyWith(claimInviteState: newState);
      }
    }
  }

  SignupState mapInviteMnemonicToState(SignupState currentState, Result result) {
    final claimInviteCurrentState = currentState.claimInviteState;

    if (result.isError) {
      return currentState.copyWith(
          claimInviteState: ClaimInviteState.error(claimInviteCurrentState, result.asError!.error.toString()));
    } else {
      final String inviteMnemonic = result.asValue!.value;

      return currentState.copyWith(
        claimInviteState: claimInviteCurrentState.copyWith(
          inviteMnemonic: inviteMnemonic,
        ),
      );
    }
  }
}
