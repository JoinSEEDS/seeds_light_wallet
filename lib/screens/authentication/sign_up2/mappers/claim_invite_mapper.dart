import 'package:seeds/datasource/remote/model/invite_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/authentication/sign_up/sign_up.i18n.dart';
import 'package:seeds/screens/authentication/sign_up2/viewmodels/signup_bloc.dart';

class ClaimInviteMapper extends StateMapper {
  SignupState mapInviteMnemonicToState(SignupState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        claimInviteView: ClaimInviteView.fail, // No screen UI for error
        pageCommand: ShowErrorMessage(''), // Error dialog
        errorMessage: result.asError!.error.toString(),
      );
    } else {
      final String inviteMnemonic = result.asValue!.value;

      return currentState.copyWith(
        claimInviteView: ClaimInviteView.processing,
        inviteMnemonic: inviteMnemonic,
      );
    }
  }

  SignupState mapValidateInviteCodeToState(SignupState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        claimInviteView: ClaimInviteView.fail, // No screen UI for error
        pageCommand: ShowErrorMessage(''), // Error dialog
        errorMessage: 'No invites found, try another code'.i18n,
      );
    } else {
      final List<InviteModel> inviteModels = result.asValue!.value;
      if (inviteModels.isNotEmpty) {
        final InviteModel inviteModel = inviteModels.first;
        if (!inviteModel.isClaimed) {
          // invite code is valid and can be claimed
          return currentState.copyWith(claimInviteView: ClaimInviteView.success, inviteModel: inviteModel);
        } else {
          // invite code is valid but claimed before
          return currentState.copyWith(
            claimInviteView: ClaimInviteView.fail, // No screen UI for error
            pageCommand: ShowErrorMessage(''), // Error dialog
            errorMessage: 'Invite was already claimed'.i18n.fill(
              [inviteModel.sponsor, inviteModel.account ?? ''],
            ),
          );
        }
      } else {
        return currentState.copyWith(
          claimInviteView: ClaimInviteView.fail, // No screen UI for error
          pageCommand: ShowErrorMessage(''), // Error dialog
          errorMessage: 'Invite hash not found, try another code'.i18n,
        );
      }
    }
  }
}
