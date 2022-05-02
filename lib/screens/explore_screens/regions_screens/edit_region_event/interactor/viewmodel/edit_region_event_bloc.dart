import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/components/select_picture_box/interactor/usecases/pick_image_usecase.dart';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/shared_use_cases/save_image_use_case.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/mappers/edit_event_location_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/mappers/edit_region_event_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/mappers/pick_image_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/mappers/save_image_url_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/usecases/edit_region_event_name_and_description_use_case.dart';

part 'edit_region_event_events.dart';

part 'edit_region_event_state.dart';

class EditRegionEventBloc extends Bloc<EditRegionEventEvents, EditRegionEventState> {
  EditRegionEventBloc(RegionEventModel event) : super(EditRegionEventState.initial(event)) {
    on<OnUpdateMapLocation>(_onUpdateMapLocations);
    on<OnSelectDateChanged>(_onSelectDateChange);
    on<OnStartTimeChanged>(_onStartTimeChange);
    on<OnEndTimeChanged>(_onEndTimeChanged);
    on<OnPickImage>(_onPickImage);
    on<OnSaveChangesTapped>(_onSaveChangesTapped);
    on<OnEventNameChange>(_onEventNameChange);
    on<OnEventDescriptionChange>(_onEventDescriptionChange);
    on<OnSaveImageNextTapped>(_onSaveImageNextTapped);
    on<ClearEditRegionEventPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _onPickImage(OnPickImage event, Emitter<EditRegionEventState> emit) async {
    emit(state.copyWith(pictureBoxState: PictureBoxState.loading));
    final result = await PickImageUseCase().run();
    emit(PickImageStateMapper().mapResultToState(state, result));
  }

  Future<void> _onSaveImageNextTapped(OnSaveImageNextTapped event, Emitter<EditRegionEventState> emit) async {
    emit(state.copyWith(isSaveChangesButtonLoading: true));

    final Result<String> urlResult = await SaveImageUseCase().run(
        SaveImageUseCaseInput(file: state.file!, pathPrefix: PathPrefix.regionEventImage, creatorId: state.event.id));

    emit(SaveImageUrlStateMapper().mapResultToState(state, urlResult));
  }

  void _onSelectDateChange(OnSelectDateChanged event, Emitter<EditRegionEventState> emit) {
    if (event.selectedDate != null) {
      emit(state.copyWith(
          newEventDateAndTime: event.selectedDate,
          eventDateAndTimeInfo: DateFormat.yMMMMEEEEd().format(event.selectedDate!)));
    }
  }

  void _onStartTimeChange(OnStartTimeChanged event, Emitter<EditRegionEventState> emit) {
    if (event.selectedTime != null) {
      final now = DateTime.now();
      final newStartTime = DateTime(now.year, now.month, now.day, event.selectedTime!.hour, event.selectedTime!.minute);

      emit(state.copyWith(
          newEventStartTime: event.selectedTime, startTimeInfo: "${DateFormat.jm().format(newStartTime)} - Stars"));
    }
  }

  void _onEndTimeChanged(OnEndTimeChanged event, Emitter<EditRegionEventState> emit) {
    if (event.selectedTime != null) {
      final now = DateTime.now();
      final newEndTime = DateTime(now.year, now.month, now.day, event.selectedTime!.hour, event.selectedTime!.minute);

      emit(state.copyWith(
          newEventEndTime: event.selectedTime, endTimeInfo: "${DateFormat.jm().format(newEndTime)} - Ends"));
    }
  }

  void _onUpdateMapLocations(OnUpdateMapLocation event, Emitter<EditRegionEventState> emit) {
    emit(EditEventLocationStateMapper().mapResultToState(state, event.place));
  }

  void _onEventNameChange(OnEventNameChange event, Emitter<EditRegionEventState> emit) {
    emit(state.copyWith(
        newRegionEventName: event.eventName,
        isSaveChangesButtonEnable: event.eventName.isNotEmpty && state.isNewDescriptionNotEmpty,
        isNewNameNotEmpty: event.eventName.isNotEmpty));
  }

  void _onEventDescriptionChange(OnEventDescriptionChange event, Emitter<EditRegionEventState> emit) {
    emit(state.copyWith(
      newRegionEventDescription: event.eventDescription,
      isNewDescriptionNotEmpty: event.eventDescription.isNotEmpty,
      isSaveChangesButtonEnable: event.eventDescription.isNotEmpty && state.isNewNameNotEmpty,
    ));
  }

  Future<void> _onSaveChangesTapped(OnSaveChangesTapped event, Emitter<EditRegionEventState> emit) async {
    emit(state.copyWith(isSaveChangesButtonLoading: true));

    final Result<String> result = await EditRegionEventEventUseCase().run(EditRegionEventInput(
      eventName: state.newRegionEventName,
      eventDescription: state.newRegionEventDescription,
      event: state.event,
      imageUrl: state.imageUrl,
      newPlace: state.newPlace,

    ));
    emit(EditRegionEventStateMapper().mapResultToState(state, result));
  }
}
