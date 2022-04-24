part of 'create_region_event_bloc.dart';

abstract class CreateRegionEventEvents extends Equatable {
  const CreateRegionEventEvents();

  @override
  List<Object?> get props => [];
}

class OnUpdateMapLocation extends CreateRegionEventEvents {
  final Place place;

  const OnUpdateMapLocation(this.place);

  @override
  String toString() => 'OnUpdateMapLocation { Place: $place}';
}

class ClearCreateRegionEventPageCommand extends CreateRegionEventEvents {
  const ClearCreateRegionEventPageCommand();

  @override
  String toString() => 'ClearCreateRegionEventPageCommand';
}

class OnNextTapped extends CreateRegionEventEvents {
  const OnNextTapped();

  @override
  String toString() => 'OnNextTapped';
}

class OnBackPressed extends CreateRegionEventEvents {
  const OnBackPressed();

  @override
  String toString() => 'OnBackPressed';
}

class OnRegionEventNameChange extends CreateRegionEventEvents {
  final String eventName;

  const OnRegionEventNameChange(this.eventName);

  @override
  String toString() => 'OnRegionEventNameChange { eventName: $eventName}';
}

class OnRegionEventDescriptionChange extends CreateRegionEventEvents {
  final String eventDescription;

  const OnRegionEventDescriptionChange(this.eventDescription);

  @override
  String toString() => 'OnRegionEventDescriptionChange {eventDescription: $eventDescription}';
}

class OnPickImage extends CreateRegionEventEvents {
  const OnPickImage();

  @override
  String toString() => 'OnPickImage';
}

class OnSelectDateChanged extends CreateRegionEventEvents {
  final DateTime? selectedDate;

  const OnSelectDateChanged(this.selectedDate);

  @override
  String toString() => 'onSelectDateChanged{newDateTime: $selectedDate}';
}

class OnSelectTimeChanged extends CreateRegionEventEvents {
  final TimeOfDay? selectedTime;

  const OnSelectTimeChanged(this.selectedTime);

  @override
  String toString() => 'onSelectDateChanged{selectedTime: $selectedTime}';
}

class OnEndTimeChanged extends CreateRegionEventEvents {
  final TimeOfDay? selectedTime;

  const OnEndTimeChanged(this.selectedTime);

  @override
  String toString() => 'OnEndTimeChanged{selectedTime: $selectedTime}';
}

class OnPickImageNextTapped extends CreateRegionEventEvents {
  const OnPickImageNextTapped();

  @override
  String toString() => 'OnPickImageNextTapped';
}

class OnPublishEventTapped extends CreateRegionEventEvents {
  const OnPublishEventTapped();

  @override
  String toString() => 'OnPublishEventTapped';
}
