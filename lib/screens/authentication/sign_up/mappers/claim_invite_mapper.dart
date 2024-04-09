import 'package:seeds/datasource/remote/model/invite_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/authentication/sign_up/signup_errors.dart';
import 'package:seeds/screens/authentication/sign_up/viewmodels/signup_bloc.dart';

class ClaimInviteMapper extends StateMapper {
  SignupState mapInviteMnemonicToState(SignupState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        claimInviteView: ClaimInviteView.fail, // No screen UI for error
        pageCommand: ShowErrorMessage(''), // Error dialog
        error: SignUpError.qRCodeScanFailed,
      );
    } else {
      final String inviteMnemonic = result.asValue!.value as String;

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
        error: SignUpError.noInvitesFound,
      );
    } else {
      final List<InviteModel> inviteModels = result.asValue!.value as List<InviteModel>;
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
            error: SignUpError.inviteAlreadyClaimed,
          );
        }
      } else {
        return currentState.copyWith(
          claimInviteView: ClaimInviteView.fail, // No screen UI for error
          pageCommand: ShowErrorMessage(''), // Error dialog
          error: SignUpError.inviteHashNotFound,
        );
      }
    }
  }
}
