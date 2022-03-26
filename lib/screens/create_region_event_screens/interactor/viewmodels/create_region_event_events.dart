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
