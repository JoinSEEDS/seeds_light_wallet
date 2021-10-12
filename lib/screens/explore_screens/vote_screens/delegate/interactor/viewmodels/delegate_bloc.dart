import 'package:bloc/bloc.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/mapper/delegate_load_data_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/usecases/delegate_load_data_usecase.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_event.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_state.dart';

class DelegateBloc extends Bloc<DelegateEvent, DelegateState> {
  DelegateBloc() : super(DelegateState.initial());

  @override
  Stream<DelegateState> mapEventToState(DelegateEvent event) async* {
    if (event is LoadDelegateData) {
      yield state.copyWith(pageState: PageState.loading);
      final Result results = await DelegateLoadDataUseCase().run();
      yield DelegateLoadDataStateMapper().mapResultToState(state, results);
    }
  }
}
