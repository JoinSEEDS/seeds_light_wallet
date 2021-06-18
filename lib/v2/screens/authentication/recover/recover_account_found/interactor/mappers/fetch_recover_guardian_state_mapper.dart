import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/usecases/fetch_recover_guardian_initial_data.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_state.dart';

class FetchRecoverRecoveryStateMapper extends StateMapper {
  RecoverAccountFoundState mapResultToState(RecoverAccountFoundState currentState, RecoverGuardianInitialDTO result) {
    List<Result> members = result.membersData;
    var linkResult = result.link;

    String? link;
    if (linkResult.isValue) {
      link = linkResult.asValue!.value;
    }

    if (areAllResultsSuccess(members) && members.isNotEmpty && link != null) {
      List<MemberModel> guardians = members.map((e) => e.asValue!.value as MemberModel).toList();

      return currentState.copyWith(
        pageState: PageState.success,
        linkToActivateGuardians: link,
        userGuardiansData: guardians,
      );
    } else {
      return currentState.copyWith(
        pageState: PageState.failure,
        errorMessage: "Oops, Something went wrong, try again later.",
      );
    }
  }
}
