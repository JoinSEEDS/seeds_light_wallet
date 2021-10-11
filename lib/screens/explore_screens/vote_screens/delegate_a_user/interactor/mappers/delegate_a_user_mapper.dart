import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_page_commands.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_state.dart';

class DelegateAUserResultMapper extends StateMapper {
  DelegateAUserState mapResultToState(DelegateAUserState currentState, Result result) {
    if (result.isError) {
      print('Error transaction hash not retrieved');
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowErrorMessage('Fail To Delegate User'),
      );
    } else {
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowDelegateUserSuccess(),
      );
    }
  }
}
