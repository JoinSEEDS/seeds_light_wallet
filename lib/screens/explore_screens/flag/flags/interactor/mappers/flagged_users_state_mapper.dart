import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/flag/flags/interactor/viewmodels/flag_bloc.dart';

class FlaggedUsersStateMapper extends StateMapper {
  FlagState mapResultToState(FlagState currentState, Result<List<ProfileModel>> result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading flagged users");
    } else {
      return currentState.copyWith(pageState: PageState.success, usersIHaveFlagged: result.asValue?.value);
    }
  }
}
