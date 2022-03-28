import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/explore/interactor/viewmodels/explore_page_command.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc() : super(ExploreState.initial()) {
    on<OnExploreCardTapped>((event, emit) => emit(state.copyWith(pageCommand: NavigateToRoute(event.route))));
    on<OnBuySeedsCardTapped>((_, emit) => emit(state.copyWith(pageCommand: NavigateToBuySeeds())));
    on<OnFlagUserTapped>((_, emit) => emit(state.copyWith(pageCommand: ShowUserFlagInformation())));
    on<OnRegionsTapped>(_onRegionsTapped);
    on<ClearExplorePageCommand>((_, emit) => emit(state.copyWith()));
  }

  void _onRegionsTapped(OnRegionsTapped event, Emitter<ExploreState> emit) {
    final command =
        settingsStorage.isFirstTimeOnRegionsScreen ? ShowIntroduceRegions() : NavigateToRoute(Routes.joinRegion);
    emit(state.copyWith(pageCommand: command));
  }
}
