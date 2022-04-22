import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/components/select_picture_box/interactor/usecases/pick_image_usecase.dart';
import 'package:seeds/components/select_picture_box/select_picture_box.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/save_image_use_case.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/mappers/change_date_state_mapper.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/mappers/change_time_state_mapper.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/mappers/pick_image_state_mapper.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/mappers/save_image_state_mapper.dart';
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
    on<OnPickImage>(_onPickImage);
    on<OnPickImageNextTapped>(_onPickImageNextTapped);
    on<OnSelectDateChanged>(_onSelectDateChange);
    on<OnSelectTimeChanged>(_onSelectTimeChange);
    on<OnEndTimeChanged>(_onEndTimeChanged);
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

  void _onSelectDateChange(OnSelectDateChanged event, Emitter<CreateRegionEventState> emit) {
    if (event.selectedDate != null) {
      emit(ChangeDateStateMapper().mapResultToState(state, event.selectedDate!));
    }
  }

  void _onEndTimeChanged(OnEndTimeChanged event, Emitter<CreateRegionEventState> emit) {
    if (event.selectedTime != null) {
      emit(state.copyWith(eventEndTime: event.selectedTime));
    }
  }

  void _onSelectTimeChange(OnSelectTimeChanged event, Emitter<CreateRegionEventState> emit) {
    if (event.selectedTime != null) {
      emit(ChangeTimeStateMapper().mapResultToState(state, event.selectedTime!));
    }
  }

  Future<void> _onPickImage(OnPickImage event, Emitter<CreateRegionEventState> emit) async {
    emit(state.copyWith(pictureBoxState: PictureBoxState.loading, imageUrl: state.imageUrl));
    final result = await PickImageUseCase().run();
    emit(PickImageStateMapper().mapResultToState(state, result));
  }

  Future<void> _onPickImageNextTapped(OnPickImageNextTapped event, Emitter<CreateRegionEventState> emit) async {
    emit(state.copyWith(isNextButtonLoading: true));
    if (state.createImageUrl) {
      final Result<String> urlResult = await SaveImageUseCase().run(SaveImageUseCaseInput(
          file: state.file!, pathPrefix: PathPrefix.regionEventImage, creatorId: state.eventName));

      emit(SaveImageStateMapper().mapResultToState(state, urlResult));
    } else {
      emit(state.copyWith(
          createRegionEventScreen: CreateRegionEventScreen.reviewAndPublish, isNextButtonLoading: false));
    }
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
        emit(state.copyWith(createRegionEventScreen: CreateRegionEventScreen.choseDataAndTime));
        break;
      case CreateRegionEventScreen.choseDataAndTime:
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
      case CreateRegionEventScreen.choseDataAndTime:
        emit(state.copyWith(createRegionEventScreen: CreateRegionEventScreen.addDescription));
        break;
      case CreateRegionEventScreen.selectBackgroundImage:
        emit(state.copyWith(createRegionEventScreen: CreateRegionEventScreen.choseDataAndTime));
        break;
      case CreateRegionEventScreen.reviewAndPublish:
        emit(state.copyWith(createRegionEventScreen: CreateRegionEventScreen.selectBackgroundImage));
        break;
    }
  }
}
