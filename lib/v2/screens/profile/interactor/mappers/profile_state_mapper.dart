import 'package:seeds/models/models.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/state_mapper.dart';
import 'package:seeds/v2/screens/profile/interactor/profile_state.dart';
import 'package:seeds/v2/screens/profile/interactor/usecases/get_profile_use_case.dart';

class ProfileStateMapper extends StateMapper<ProfileModel, ProfileState> {
  @override
  ProfileState mapToState(ProfileState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError.error.toString());
    } else {
      return currentState.copyWith(pageState: PageState.success, profile: result.asValue.value);
    }
  }
}
