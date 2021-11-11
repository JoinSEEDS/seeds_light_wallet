import 'package:bloc/bloc.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/mapper/load_delegators_data_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/usecase/load_delegators_data_usecase.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/viewmodels/delegator_event.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/viewmodels/delegator_state.dart';

class DelegatorBloc extends Bloc<DelegatorEvent, DelegatorState> {
  DelegatorBloc() : super(DelegatorState.initial());

  @override
  Stream<DelegatorState> mapEventToState(DelegatorEvent event) async* {
    if (event is LoadDelegatorData) {
      yield state.copyWith(pageState: PageState.loading);
      final List<Result> result = await LoadDelegatorsDataUseCase().run();
      yield LoadDelegatorsDataStateMapper().mapResultToState(state, result);
    }
  }
}
