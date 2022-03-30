import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/viewmodels/edit_name_bloc.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/viewmodels/page_commands.dart';

class UpdateProfileStateMapper extends StateMapper {
  EditNameState mapResultToState(EditNameState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError!.error.toString());
    } else {
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: EditNameSuccess(),
      );
    }
  }
}
