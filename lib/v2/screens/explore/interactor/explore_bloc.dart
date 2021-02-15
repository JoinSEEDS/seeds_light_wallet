import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/state_mapper.dart';
import 'package:seeds/v2/screens/explore/interactor/mappers/explore_state_mapper.dart';
import 'package:seeds/v2/screens/explore/interactor/usecases/get_explore_page_data_use_case.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/explore_events.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/explore_state.dart';
import 'package:seeds/v2/screens/profile/interactor/usecases/get_profile_use_case.dart';

/// --- BLOC
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc() : super(ExploreState.initial());

  @override
  Stream<ExploreState> mapEventToState(ExploreEvent event) async* {
    if (event is LoadExplore) {
      yield state.copyWith(pageState: PageState.loading);

      List<Result> results = await GetExploreUseCase().run(event.userName);
      yield ExploreStateMapper().mapResultsToState(state, results);
    }
  }
}
