import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/invite_bloc.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/invite_page_command.dart';
import 'package:seeds/screens/explore_screens/invite/invite_errors.dart';

class CreateInviteResultStateMapper extends StateMapper {
  InviteState mapResultsToState(InviteState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      // The 2 calls are error --> transaction fail show snackbar fail
      print('Error transaction hash not retrieved');
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowErrorMessage(InviteError.inviteFail),
        isCreateInviteButtonEnabled: false,
      );
    } else {
      // Check if the error is in the transaction
      results.retainWhere((Result element) => element.isValue);
      final values = results.map((Result element) => element.asValue!.value) as List;
      final TransactionResponse? response = values.firstWhere((i) => i is TransactionResponse, orElse: () => null) as TransactionResponse?;

      if (response != null && response.transactionId.isNotEmpty) {
        // Transaction success show invite link dialog
        final Uri? dynamicSecretLink = values.firstWhere((i) => i is Uri, orElse: () => null) as Uri?;

        return currentState.copyWith(
          pageState: PageState.success,
          pageCommand: ShowInviteLinkView(),
          dynamicSecretLink: dynamicSecretLink.toString(),
        );
      } else {
        // Transaction fail show snackbar fail
        print('Error transaction hash not retrieved');
        return currentState.copyWith(
          pageState: PageState.success,
          pageCommand: ShowErrorMessage(InviteError.inviteFail),
          isCreateInviteButtonEnabled: false,
        );
      }
    }
  }
}
