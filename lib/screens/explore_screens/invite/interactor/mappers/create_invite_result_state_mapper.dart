import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/explore_screens/invite/invite.i18n.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/invite_bloc.dart';

class CreateInviteResultStateMapper extends StateMapper {
  InviteState mapResultsToState(InviteState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      // The 2 calls are error --> transaction fail show snackbar fail
      print('Error transaction hash not retrieved');
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowErrorMessage('Invite creation failed, try again.'.i18n),
        isCreateInviteButtonEnabled: false,
      );
    } else {
      // Check if the error is in the transaction
      results.retainWhere((Result element) => element.isValue);
      final values = results.map((Result element) => element.asValue!.value).toList();
      final TransactionResponse? response = values.firstWhere((i) => i is TransactionResponse, orElse: () => null);

      if (response != null && response.transactionId.isNotEmpty) {
        // Transaction success show invite link dialog
        final Uri? dynamicSecretLink = values.firstWhere((i) => i is Uri, orElse: () => null);

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
          pageCommand: ShowErrorMessage('Invite creation failed, try again.'.i18n),
          isCreateInviteButtonEnabled: false,
        );
      }
    }
  }
}
