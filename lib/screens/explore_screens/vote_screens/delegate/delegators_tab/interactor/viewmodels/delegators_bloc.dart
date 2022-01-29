import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/mapper/load_delegators_data_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/interactor/usecase/load_delegators_data_usecase.dart';

part 'delegators_event.dart';
part 'delegators_state.dart';

class DelegatorsBloc extends Bloc<DelegatorsEvent, DelegatorsState> {
  DelegatorsBloc() : super(DelegatorsState.initial()) {
    on<OnLoadDelegatorsData>(_onLoadDelegatorsData);
  }

  Future<void> _onLoadDelegatorsData(OnLoadDelegatorsData event, Emitter<DelegatorsState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final List<Result> result = await LoadDelegatorsDataUseCase().run();
    emit(LoadDelegatorsDataStateMapper().mapResultToState(state, result));
  }
}
