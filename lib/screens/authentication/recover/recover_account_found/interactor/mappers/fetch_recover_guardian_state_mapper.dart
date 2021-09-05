import 'package:seeds/datasource/remote/model/account_guardians_model.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/datasource/remote/model/user_recover_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/usecases/fetch_recover_guardian_initial_data.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_state.dart';
import 'package:seeds/i18n/authentication/recover/recover.i18n.dart';

class FetchRecoverRecoveryStateMapper extends StateMapper {
  RecoverAccountFoundState mapResultToState(RecoverAccountFoundState currentState, RecoverGuardianInitialDTO result) {
    final List<Result> members = result.membersData;
    final Result linkResult = result.link;
    final Result userRecoversModel = result.userRecoversModel;
    final Result accountGuardians = result.accountGuardians;

    final Uri? link = linkResult.asValue?.value;
    final UserRecoversModel? userRecoversModelData = userRecoversModel.asValue?.value;
    final UserGuardiansModel? userGuardiansModel = accountGuardians.asValue?.value;

    final hasFetchedGuardians = areAllResultsSuccess(members);
    final hasGuardians = members.isNotEmpty;

    // Check that we have all data needed from the server and it is valid.
    // We need data from multiple services and any of them can fail.
    // This is the minimum required data to proceed
    if (hasFetchedGuardians &&
        hasGuardians &&
        link != null &&
        userRecoversModelData != null &&
        userGuardiansModel != null) {
      final List<MemberModel> guardians = members.map((e) => e.asValue!.value as MemberModel).toList();
      final confirmedGuardianSignatures = userRecoversModelData.alreadySignedGuardians.length;

      // check how long we have to wait before we can claim (24h delay is standard)
      final timeLockSeconds = userRecoversModelData.completeTimestamp + userGuardiansModel.timeDelaySec;

      RecoveryStatus recoveryStatus;
      // for 3 signers, we need 2/3 signatures. For 4 or 5 signers, we need 3+ signatures.
      if ((userGuardiansModel.guardians.length == 3 && confirmedGuardianSignatures >= 2) ||
          (userGuardiansModel.guardians.length > 3 && confirmedGuardianSignatures >= 3)) {
        if (timeLockSeconds <= DateTime.now().millisecondsSinceEpoch / 1000) {
          recoveryStatus = RecoveryStatus.READY_TO_CLAIM_ACCOUNT;
        } else {
          recoveryStatus = RecoveryStatus.WAITING_FOR_24_HOUR_COOL_PERIOD;
        }
      } else {
        recoveryStatus = RecoveryStatus.WAITING_FOR_GUARDIANS_TO_SIGN;
      }

      // (Gery)
      // I know that the private key is already saved or the existing one
      // is used at the beginning of this process, so it is redundant here.
      // But, could you confirm me if it is REALLY NESSESARY to save the accountName here?

      // SaveAccountUseCase().run(accountName: currentState.userAccount, privateKey: result.privateKey);

      return currentState.copyWith(
        pageState: PageState.success,
        linkToActivateGuardians: link,
        userGuardiansData: guardians,
        confirmedGuardianSignatures: confirmedGuardianSignatures,
        recoveryStatus: recoveryStatus,
        alreadySignedGuardians: userRecoversModelData.alreadySignedGuardians,
        timeLockSeconds: timeLockSeconds,
      );
    } else if (hasFetchedGuardians && !hasGuardians) {
      return currentState.copyWith(
        pageState: PageState.failure,
        errorMessage: "There are no guardians for this account.".i18n,
      );
    } else {
      return currentState.copyWith(
        pageState: PageState.failure,
        errorMessage: "Oops! Something went wrong, try again later.".i18n,
      );
    }
  }
}
