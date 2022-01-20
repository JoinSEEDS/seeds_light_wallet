import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/flag/flags/interactor/viewmodels/flag_bloc.dart';

class RemoveFlagStateMapper extends StateMapper {
  FlagState mapResultToState(FlagState currentState, Result<TransactionResponse> result, String removedUserAccount) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error removing flag from user");
    } else {
      // Remove the user that was just flag removed from server
      currentState.usersIHaveFlagged.removeWhere((element) => element.account == removedUserAccount);
      return currentState.copyWith(pageState: PageState.success, usersIHaveFlagged: currentState.usersIHaveFlagged);
    }
  }
}
