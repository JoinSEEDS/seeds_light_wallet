import 'package:flutter/material.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class ChangeStartTimeStateMapper extends StateMapper {
  CreateRegionEventState mapResultToState(CreateRegionEventState currentState, TimeOfDay eventStartTime) {
    if (currentState.eventStartTime != null) {
      return currentState.copyWith(
          eventStartTime: DateTime(
        currentState.eventStartTime!.year,
        currentState.eventStartTime!.month,
        currentState.eventStartTime!.day,
        eventStartTime.hour,
        eventStartTime.minute,
      ));
    } else {
      final now = DateTime.now();
      return currentState.copyWith(
          eventStartTime: DateTime(
        now.year,
        now.month,
        now.day,
        eventStartTime.hour,
        eventStartTime.minute,
      ));
    }
  }
}
