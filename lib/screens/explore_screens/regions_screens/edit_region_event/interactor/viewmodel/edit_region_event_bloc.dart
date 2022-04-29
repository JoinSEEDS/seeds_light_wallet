import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

part 'edit_region_event_events.dart';

part 'edit_region_event_state.dart';

class EditRegionEventBloc extends Bloc<EditRegionEventEvents, EditRegionEventState> {
  EditRegionEventBloc(RegionEventModel event) : super(EditRegionEventState.initial(event)) {
    on<OnUpdateMapLocation>(_onUpdateMapLocations);
    on<OnSelectDateChanged>(_onSelectDateChange);
    on<OnStartTimeChanged>(_onStartTimeChange);
    on<OnEndTimeChanged>(_onEndTimeChanged);
    on<ClearEditRegionEventPageCommand>((_, emit) => emit(state.copyWith()));
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
    emit(state.copyWith(newPlace: event.place));
  }
}
