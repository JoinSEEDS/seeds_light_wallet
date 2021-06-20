import 'package:seeds/v2/datasource/remote/model/account_guardians_model.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/datasource/remote/model/user_recover_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/usecases/fetch_recover_guardian_initial_data.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_state.dart';

class FetchRecoverRecoveryStateMapper extends StateMapper {
  RecoverAccountFoundState mapResultToState(RecoverAccountFoundState currentState, RecoverGuardianInitialDTO result) {
    List<Result> members = result.membersData;
    Result linkResult = result.link;
    Result userRecoversModel = result.userRecoversModel;
    Result accountGuardians = result.accountGuardians;

    String? link;
    if (linkResult.isValue) {
      link = linkResult.asValue!.value;
    }

    UserRecoversModel? userRecoversModelData;
    if (userRecoversModel.isValue) {
      userRecoversModelData = userRecoversModel.asValue!.value;
    }

    UserGuardiansModel? userGuardiansModel;
    if (accountGuardians.isValue) {
      userGuardiansModel = accountGuardians.asValue!.value;
    }

    if (areAllResultsSuccess(members) &&
        members.isNotEmpty &&
        link != null &&
        userRecoversModelData != null &&
        userGuardiansModel != null) {
      List<MemberModel> guardians = members.map((e) => e.asValue!.value as MemberModel).toList();
      var confirmedGuardianSignatures = userRecoversModelData.alreadySignedGuardians.length;

      // check how long we have to wait before we can claim (24h delay is standard)
      var timeLockSeconds = userRecoversModelData.completeTimestamp + userGuardiansModel.timeDelaySec;

      bool isAccountReadyToClaim;
      bool isAccountMissingSignatures;
      // for 3 signers, we need 2/3 signatures. For 4 or 5 signers, we need 3+ signatures.
      if ((userGuardiansModel.guardians.length == 3 && confirmedGuardianSignatures >= 2) ||
          (userGuardiansModel.guardians.length > 3 && confirmedGuardianSignatures >= 3)) {
        isAccountMissingSignatures = false;

        if (timeLockSeconds <= DateTime.now().millisecondsSinceEpoch / 1000) {
          isAccountReadyToClaim = true;
        } else {
          isAccountReadyToClaim = false;
        }
      } else {
        isAccountReadyToClaim = false;
        isAccountMissingSignatures = true;
      }

      return currentState.copyWith(
        pageState: PageState.success,
        linkToActivateGuardians: link,
        userGuardiansData: guardians,
        confirmedGuardianSignatures: confirmedGuardianSignatures,
        isAccountReadyToClaim: isAccountReadyToClaim,
        isAccountMissingSignatures: isAccountMissingSignatures,
        alreadySignedGuardians: userRecoversModelData.alreadySignedGuardians
      );
    } else {
      return currentState.copyWith(
        pageState: PageState.failure,
        errorMessage: "Oops, Something went wrong, try again later.",
      );
    }
  }
}
