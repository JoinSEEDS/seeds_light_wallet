import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/mappers/edit_region_event_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/usecases/edit_region_event_name_and_description_use_case.dart';

part 'edit_region_event_events.dart';

part 'edit_region_event_state.dart';

class EditRegionEventBloc extends Bloc<EditRegionEventEvents, EditRegionEventState> {
  EditRegionEventBloc(RegionEventModel event) : super(EditRegionEventState.initial(event)) {
    on<OnSaveChangesTapped>(_onSaveChangesTapped);
    on<OnEventNameChange>(_onEventNameChange);
    on<OnEventDescriptionChange>(_onEventDescriptionChange);
    on<ClearEditRegionEventPageCommand>((_, emit) => emit(state.copyWith()));
  }

  void _onEventNameChange(OnEventNameChange event, Emitter<EditRegionEventState> emit) {
    emit(state.copyWith(
        newRegionEventName: event.eventName,
        isSaveChangesButtonEnable: true,
        isNewNameNotEmpty: event.eventName.isNotEmpty));
  }

  void _onEventDescriptionChange(OnEventDescriptionChange event, Emitter<EditRegionEventState> emit) {
    emit(state.copyWith(
      newRegionEventDescription: event.eventDescription,
      isNewDescriptionNotEmpty: event.eventDescription.isNotEmpty,
      isSaveChangesButtonEnable: true,
    ));
  }

  Future<void> _onSaveChangesTapped(OnSaveChangesTapped event, Emitter<EditRegionEventState> emit) async {
    emit(state.copyWith(isSaveChangesButtonLoading: true));

    final Result<String> result = await EditRegionEventNameAndDescriptionEventUseCase().run(CreateRegionEventInput(
        eventName: state.newRegionEventName.isEmpty ? state.event.eventName : state.newRegionEventName,
        eventDescription:
            state.newRegionEventDescription.isEmpty ? state.event.eventDescription : state.newRegionEventDescription,
        event: state.event));
    emit(EditRegionEventStateMapper().mapResultToState(state, result));
  }
}
