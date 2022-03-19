part of 'create_region_event_bloc.dart';

abstract class CreateRegionEventEvents extends Equatable {
  const CreateRegionEventEvents();

  @override
  List<Object?> get props => [];
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

class OnRegionEventDescriptionChange extends CreateRegionEventEvents {
  final String eventDescription;

  const OnRegionEventDescriptionChange(this.eventDescription);

  @override
  String toString() => 'OnRegionEventDescriptionChange {eventDescription: $eventDescription}';
}
