import 'package:flutter/material.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class ChangeEndTimeStateMapper extends StateMapper {
  CreateRegionEventState mapResultToState(CreateRegionEventState currentState, TimeOfDay eventEndTime) {
    if (currentState.eventEndTime != null) {
      return currentState.copyWith(
          eventEndTime: DateTime(
        currentState.eventEndTime!.year,
        currentState.eventEndTime!.month,
        currentState.eventEndTime!.day,
        eventEndTime.hour,
        eventEndTime.minute,
      ));
    } else {
      final now = DateTime.now();
      return currentState.copyWith(
          eventEndTime: DateTime(
        now.year,
        now.month,
        now.day,
        eventEndTime.hour,
        eventEndTime.minute,
      ));
    }
  }
}
