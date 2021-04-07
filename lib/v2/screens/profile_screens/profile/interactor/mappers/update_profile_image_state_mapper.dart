import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_response.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/viewmodels/profile_state.dart';

class UpdateProfileImageStateMapper extends StateMapper {
  ProfileState mapResultToState(ProfileState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError.error.toString());
    } else {
      final TransactionResponse res = result.asValue.value;
      return currentState.copyWith(
        pageState: PageState.success,
        profile: currentState.profile.copyWith(image: res.data.image),
      );
    }
  }
}
