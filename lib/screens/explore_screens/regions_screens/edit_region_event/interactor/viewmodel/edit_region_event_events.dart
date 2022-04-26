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
