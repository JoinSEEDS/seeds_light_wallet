import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/state_mapper.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/explore_state.dart';
import 'package:seeds/v2/screens/profile/interactor/usecases/get_profile_use_case.dart';

class ExploreStateMapper extends StateMapper<ProfileModel, ExploreState> {
  @override
  ExploreState mapToState(ExploreState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError.error.toString());
    } else {
      return currentState.copyWith(pageState: PageState.success, profile: result.asValue.value);
    }
  }
}
