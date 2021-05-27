import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/planted_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/explore/interactor/mappers/explore_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/explore/interactor/usecases/get_explore_data_use_case.dart';
import 'package:seeds/v2/screens/explore_screens/explore/interactor/viewmodels/bloc.dart';

/// --- BLOC
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc() : super(ExploreState.initial());

  @override
  Stream<ExploreState> mapEventToState(ExploreEvent event) async* {
    if (event is LoadExploreData) {
      yield state.copyWith(pageState: PageState.loading);
      var results = await GetExploreDataUseCase().run();
      yield ExploreStateMapper().mapResultsToState(state, results);
    }
    if (event is OnPlantedSeedsValueUpdate) {
      var availableSeeds = state.availableSeeds!.quantity - event.plantedSeeds;
      var plantedSeeds = state.plantedSeeds!.quantity + event.plantedSeeds;
      yield state.copyWith(
        availableSeeds: BalanceModel(availableSeeds),
        plantedSeeds: PlantedModel(plantedSeeds),
      );
    }
    if (event is OnAvailableSeedsValueUpdate) {
      var availableSeeds = state.availableSeeds!.quantity - event.spentSeeds;
      yield state.copyWith(availableSeeds: BalanceModel(availableSeeds));
    }
  }
}
