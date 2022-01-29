import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/viewmodels/vouched_bloc.dart';

class LoadVouchedListStateMapper extends StateMapper {
  VouchedState mapResultToState(VouchedState currentState, Result<List<ProfileModel>> result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Vouched");
    } else {
      return currentState.copyWith(
        pageState: PageState.success,
        vouched: result.asValue!.value,
      );
    }
  }
}
