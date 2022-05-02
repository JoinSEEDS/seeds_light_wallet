import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class ChangeStartDateStateMapper extends StateMapper {
  CreateRegionEventState mapResultToState(CreateRegionEventState currentState, DateTime eventStartDate) {
    // Update times with the new date if they are not null
    if (currentState.eventStartTime != null) {
      return currentState.copyWith(
          eventStartTime: DateTime(
        eventStartDate.year,
        eventStartDate.month,
        eventStartDate.day,
        currentState.eventStartTime!.hour,
        currentState.eventStartTime!.minute,
        currentState.eventStartTime!.second,
        currentState.eventStartTime!.millisecond,
      ));
    } else {
      return currentState.copyWith(
          eventStartTime: DateTime(eventStartDate.year, eventStartDate.month, eventStartDate.day));
    }
  }
}
