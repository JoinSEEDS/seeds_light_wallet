import 'package:seeds/v2/datasource/remote/model/transaction_response.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/invite/interactor/viewmodels/invite_state.dart';

class CreateInviteResultStateMapper extends StateMapper {
  InviteState mapResultsToState(InviteState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error creating invite');
    } else {
      print('CreateInviteResultStateMapper mapResultsToState length = ${results.length}');
      results.retainWhere((Result element) => element.isValue);
      var values = results.map((Result element) => element.asValue!.value).toList();

      TransactionResponse? response = values.firstWhere((i) => i is TransactionResponse, orElse: () => null);

      if (response != null && response.transactionId.isNotEmpty) {
        Uri? dynamicSecretLink = values.firstWhere((i) => i is Uri, orElse: () => null);

        return currentState.copyWith(
          pageState: PageState.success,
          showInviteLinkDialog: true,
          dynamicSecretLink: dynamicSecretLink.toString(),
        );
      } else {
        // Show a dialog or snack to retry?? we do not have yet a desing for this.
        return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error creating invite');
      }
    }
  }
}
