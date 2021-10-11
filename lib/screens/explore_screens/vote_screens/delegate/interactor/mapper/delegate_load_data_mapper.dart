import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_state.dart';

class DelegateLoadDataStateMapper extends StateMapper {
  DelegateState mapResultToState(DelegateState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.failure,
      );
    } else {
      final DelegateModel delegate = result.asValue!.value as DelegateModel;

      if (delegate.delegatee == '') {
        return currentState.copyWith(pageState: PageState.success, activeDelegate: false, delegate: delegate);
      } else {
        return currentState.copyWith(pageState: PageState.success, activeDelegate: true, delegate: delegate);
      }
    }
  }
}
