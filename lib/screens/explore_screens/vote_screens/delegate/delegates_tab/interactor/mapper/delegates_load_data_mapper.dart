import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegates_bloc.dart';

class DelegatesLoadDataStateMapper extends StateMapper {
  DelegatesState mapResultToState(DelegatesState currentState, Result? result) {
    if (result == null) {
      return currentState.copyWith(pageState: PageState.failure);
    } else {
      if (result.asValue!.value is ProfileModel) {
        final ProfileModel delegateMember = result.asValue!.value as ProfileModel;
        return currentState.copyWith(pageState: PageState.success, activeDelegate: true, delegate: delegateMember);
      } else {
        return currentState.copyWith(
          pageState: PageState.success,
          activeDelegate: false,
        );
      }
    }
  }
}
