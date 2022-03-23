import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_events_page_commands.dart';

part 'create_region_event_events.dart';

part 'create_region_event_state.dart';

class CreateRegionEventBloc extends Bloc<CreateRegionEventEvents, CreateRegionEventState> {
  CreateRegionEventBloc() : super(CreateRegionEventState.initial()) {
    on<OnNextTapped>(_onNextTapped);
    on<OnBackPressed>(_onBackPressed);
    on<OnUpdateMapLocation>(_onUpdateMapLocations);
    on<OnRegionEventNameChange>(_onRegionEventNameChange);
    on<OnRegionEventDescriptionChange>(_onRegionEventDescriptionChange);
    on<ClearCreateRegionEventPageCommand>((_, emit) => emit(state.copyWith()));
  }

  void _onUpdateMapLocations(OnUpdateMapLocation event, Emitter<CreateRegionEventState> emit) {
    emit(state.copyWith(currentPlace: event.place));
  }

  void _onRegionEventNameChange(OnRegionEventNameChange event, Emitter<CreateRegionEventState> emit) {
    emit(state.copyWith(eventName: event.eventName));
  }

  void _onRegionEventDescriptionChange(OnRegionEventDescriptionChange event, Emitter<CreateRegionEventState> emit) {
    emit(state.copyWith(eventDescription: event.eventDescription));
  }

  void _onNextTapped(OnNextTapped event, Emitter<CreateRegionEventState> emit) {
    switch (state.createRegionEventScreen) {
      case CreateRegionEventScreen.selectLocation:
        emit(state.copyWith(createRegionEventScreen: CreateRegionEventScreen.displayName));
        break;
      case CreateRegionEventScreen.displayName:
        emit(state.copyWith(createRegionEventScreen: CreateRegionEventScreen.addDescription));
        break;
      case CreateRegionEventScreen.addDescription:
        emit(state.copyWith(createRegionEventScreen: CreateRegionEventScreen.selectBackgroundImage));
        break;
      case CreateRegionEventScreen.selectBackgroundImage:
        emit(state.copyWith(createRegionEventScreen: CreateRegionEventScreen.reviewAndPublish));
        break;
      case CreateRegionEventScreen.reviewAndPublish:
        break;
    }
  }

  void _onBackPressed(OnBackPressed event, Emitter<CreateRegionEventState> emit) {
    switch (state.createRegionEventScreen) {
      case CreateRegionEventScreen.selectLocation:
        emit(state.copyWith(pageCommand: ReturnToRegionScreen()));
        break;
      case CreateRegionEventScreen.displayName:
        emit(state.copyWith(createRegionEventScreen: CreateRegionEventScreen.selectLocation));
        break;
      case CreateRegionEventScreen.addDescription:
        emit(state.copyWith(createRegionEventScreen: CreateRegionEventScreen.displayName));
        break;
      case CreateRegionEventScreen.selectBackgroundImage:
        emit(state.copyWith(createRegionEventScreen: CreateRegionEventScreen.addDescription));
        break;
      case CreateRegionEventScreen.reviewAndPublish:
        emit(state.copyWith(createRegionEventScreen: CreateRegionEventScreen.selectBackgroundImage));
        break;
    }
  }
}
