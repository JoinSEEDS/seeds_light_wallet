import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/flag/flag_user/interactor/viewmodel/flag_user_bloc.dart';
import 'package:seeds/screens/explore_screens/flag/flag_user/interactor/viewmodel/flag_user_page_commands.dart';

class FlagUserStateMapper extends StateMapper {
  FlagUserState mapResultToState(FlagUserState currentState, Result<TransactionResponse> result) {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.failure,
        pageCommand: ShowErrorMessage("Error when flagging user"),
      );
    } else {
      return currentState.copyWith(pageState: PageState.success, pageCommand: ShowFlagUserSuccess());
    }
  }
}
