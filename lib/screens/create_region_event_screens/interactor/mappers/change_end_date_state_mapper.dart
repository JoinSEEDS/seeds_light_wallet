import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class ChangeEndDateStateMapper extends StateMapper {
  CreateRegionEventState mapResultToState(CreateRegionEventState currentState, DateTime eventEndDate) {
    // Update times with the new date if they are not null
    if (currentState.eventEndTime != null) {
      return currentState.copyWith(
          eventEndTime: DateTime(
        eventEndDate.year,
        eventEndDate.month,
        eventEndDate.day,
        currentState.eventEndTime!.hour,
        currentState.eventEndTime!.minute,
        currentState.eventEndTime!.second,
        currentState.eventEndTime!.millisecond,
      ));
    } else {
      return currentState.copyWith(eventEndTime: DateTime(eventEndDate.year, eventEndDate.month, eventEndDate.day));
    }
  }
}
