import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profile_bloc.dart';

class UpdateProfileImageStateMapper extends StateMapper {
  ProfileState mapResultToState(ProfileState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError!.error.toString());
    } else {
      final TransactionResponse res = result.asValue!.value as TransactionResponse;
      return currentState.copyWith(
        pageState: PageState.success,
        profile: currentState.profile!.copyWith(image: res.data!.image),
      );
    }
  }
}
