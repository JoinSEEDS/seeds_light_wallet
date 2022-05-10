part of 'edit_region_event_bloc.dart';

abstract class EditRegionEventEvents extends Equatable {
  const EditRegionEventEvents();

  @override
  List<Object?> get props => [];
}

class ClearEditRegionEventPageCommand extends EditRegionEventEvents {
  const ClearEditRegionEventPageCommand();

  @override
  String toString() => 'ClearEditRegionEventPageCommand';
}

class OnPickImage extends EditRegionEventEvents {
  const OnPickImage();

  @override
  String toString() => 'OnPickImage';
}

class OnUpdateMapLocation extends EditRegionEventEvents {
  final Place place;

  const OnUpdateMapLocation(this.place);

  @override
  String toString() => 'OnUpdateMapLocation { Place: $place}';
}

class OnSelectDateChanged extends EditRegionEventEvents {
  final DateTime? selectedDate;

  const OnSelectDateChanged(this.selectedDate);

  @override
  String toString() => 'onSelectDateChanged{newDateTime: $selectedDate}';
}

class OnStartTimeChanged extends EditRegionEventEvents {
  final TimeOfDay? selectedTime;

  const OnStartTimeChanged(this.selectedTime);

  @override
  String toString() => 'onSelectDateChanged{selectedTime: $selectedTime}';
}

class OnEndTimeChanged extends EditRegionEventEvents {
  final TimeOfDay? selectedTime;

  const OnEndTimeChanged(this.selectedTime);

  @override
  String toString() => 'OnEndTimeChanged{selectedTime: $selectedTime}';
}

class OnSelectStartDateButtonTapped extends EditRegionEventEvents {
  const OnSelectStartDateButtonTapped();

  @override
  String toString() => 'OnSelectStartDateButtonTapped';
}

class OnEventNameChange extends EditRegionEventEvents {
  final String eventName;

  const OnEventNameChange(this.eventName);

  @override
  String toString() => 'OnEventNameChange {eventName: $eventName}';
}

class OnEventDescriptionChange extends EditRegionEventEvents {
  final String eventDescription;

  const OnEventDescriptionChange(this.eventDescription);

  @override
  String toString() => 'OnEventDescriptionChange {eventDescription: $eventDescription}';
}

class OnSaveChangesTapped extends EditRegionEventEvents {
  const OnSaveChangesTapped();

  @override
  String toString() => 'OnSaveChangesTapped';
}

class OnSaveImageNextTapped extends EditRegionEventEvents {
  const OnSaveImageNextTapped();

  @override
  String toString() => 'OnSaveImageNextTapped';
}
