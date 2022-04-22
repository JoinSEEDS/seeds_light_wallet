import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/create_region_event_screens/interactor/viewmodels/create_region_event_bloc.dart';

class ChangeDateStateMapper extends StateMapper {
  CreateRegionEventState mapResultToState(CreateRegionEventState currentState, DateTime eventDate) {
    DateTime selectedDate;

    //If time is already selected, create a new DateTime with the current date
    if (currentState.eventStartTime != null) {
      selectedDate = DateTime(
        eventDate.year,
        eventDate.month,
        eventDate.day,
        currentState.eventStartTime!.hour,
        currentState.eventStartTime!.minute,
      );
    } else {
      selectedDate = eventDate;
    }

    return currentState.copyWith(
      eventDateAndTime: selectedDate,
      eventDate: eventDate,
    );
  }
}
