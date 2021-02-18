import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile/interactor/usecases/get_profile_use_case.dart';
import 'package:seeds/v2/screens/profile/interactor/viewmodels/profile_state.dart';

class ProfileStateMapper extends StateMapper<ProfileModel, ProfileState> {
  @override
  ProfileState mapResultToState(ProfileState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError.error.toString());
    } else {
      return currentState.copyWith(pageState: PageState.success, profile: result.asValue.value);
    }
  }
}
