import 'package:flutter/material.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class ChangeTimeStateMapper extends StateMapper {
  CreateRegionEventState mapResultToState(CreateRegionEventState currentState, TimeOfDay eventTime) {
    DateTime selectedTimeFormat;

    //If Date is not selected yet, create a new DateTime with just the time
    if (currentState.eventDate != null) {
      selectedTimeFormat = DateTime(currentState.eventDate!.year, currentState.eventDate!.month,
          currentState.eventDate!.day, eventTime.hour, eventTime.minute);
    } else {
      selectedTimeFormat = DateTime(0, 0, 0, eventTime.hour, eventTime.minute);
    }

    return currentState.copyWith(
      eventDateAndTime: selectedTimeFormat,
      eventTime: eventTime,
    );
  }
}
