import 'package:bloc/bloc.dart';
import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/usecase/delegate_load_data_usecase.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/usecase/load_delegate_as_member_use_case.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegate_event.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/mapper/delegator_load_data_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/viewmodels/delegator_event.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/viewmodels/delegator_state.dart';

class DelegatorBloc extends Bloc<DelegatorEvent, DelegatorState> {
  DelegatorBloc() : super(DelegatorState.initial());

  @override
  Stream<DelegatorState> mapEventToState(DelegatorEvent event) async* {
    if (event is LoadDelegateData) {
      yield state.copyWith(pageState: PageState.loading);
      final Result result = await DelegateLoadDataUseCase().run();

      if (!result.isError && result.asValue != null && result.asValue!.value is DelegateModel) {
        final DelegateModel delegate = result.asValue!.value;

        if (delegate.delegatee.isNotEmpty) {
          final Result memberResult = await LoadDelegateAsMemberUseCase().run(delegateAccount: delegate.delegatee);
          yield DelegatorLoadDataStateMapper().mapResultToState(state, memberResult);
        } else {
          yield DelegatorLoadDataStateMapper().mapResultToState(state, result);
        }
      }
    }
  }
}
