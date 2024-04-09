import 'package:seeds/datasource/remote/model/account_guardians_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/user_recover_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/domain-shared/shared_use_cases/save_account_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/start_recovery_use_case.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/usecases/fetch_recover_guardian_initial_data.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_bloc.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/recover_account_found_errors.dart';

class FetchRecoverRecoveryStateMapper extends StateMapper {
  RecoverAccountFoundState mapResultToState(RecoverAccountFoundState currentState, RecoverGuardianInitialDTO result) {
    final List<Result> members = result.membersData;
    final Result linkResult = result.link;
    final Result userRecoversModel = result.userRecoversModel;
    final Result accountGuardians = result.accountGuardians;

    final Uri? link = linkResult.asValue?.value as Uri?;
    final UserRecoversModel? userRecoversModelData = userRecoversModel.asValue?.value as UserRecoversModel?;
    final UserGuardiansModel? userGuardiansModel = accountGuardians.asValue?.value as UserGuardiansModel?;

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
      final List<ProfileModel> guardians = members.map((e) => e.asValue!.value as ProfileModel).toList();
      final confirmedGuardianSignatures = userRecoversModelData.alreadySignedGuardians.length;

      // check how long we have to wait before we can claim (24h delay is standard)
      final timeLockExpirySeconds = userRecoversModelData.completeTimestamp + userGuardiansModel.timeDelaySec;

      RecoveryStatus recoveryStatus;
      // for 3 signers, we need 2/3 signatures. For 4 or 5 signers, we need 3+ signatures.
      if ((userGuardiansModel.guardians.length == 3 && confirmedGuardianSignatures >= 2) ||
          (userGuardiansModel.guardians.length > 3 && confirmedGuardianSignatures >= 3)) {
        if (timeLockExpirySeconds <= DateTime.now().millisecondsSinceEpoch / 1000) {
          recoveryStatus = RecoveryStatus.readyToClaimAccount;
        } else {
          recoveryStatus = RecoveryStatus.waitingFor24HourCoolPeriod;
        }
      } else {
        recoveryStatus = RecoveryStatus.waitingForGuardiansToSign;
      }

      /// Save Recovery values
      StartRecoveryUseCase().run(
        accountName: currentState.userAccount,
        authData: result.authData,
        recoveryLink: link.toString(),
      );

      // Save the private key and account
      SaveAccountUseCase().run(accountName: currentState.userAccount, authData: result.authData);

      return currentState.copyWith(
        pageState: PageState.success,
        linkToActivateGuardians: link,
        userGuardiansData: guardians,
        confirmedGuardianSignatures: confirmedGuardianSignatures,
        recoveryStatus: recoveryStatus,
        alreadySignedGuardians: userRecoversModelData.alreadySignedGuardians,
        timeLockExpirySeconds: timeLockExpirySeconds,
      );
    } else if (hasFetchedGuardians && !hasGuardians) {
      return currentState.copyWith(
        pageState: PageState.failure,
        error: RecoverAccountFoundError.noGuardians,
      );
    } else {
      return currentState.copyWith(
        pageState: PageState.failure,
        error: RecoverAccountFoundError.unknown,
      );
    }
  }
}
