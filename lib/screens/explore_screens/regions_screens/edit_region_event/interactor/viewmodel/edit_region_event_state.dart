part of 'edit_region_event_bloc.dart';

class EditRegionEventState extends Equatable {
  final String newRegionEventDescription;
  final String newRegionEventName;
  final RegionEventModel event;
  final bool isSaveChangesButtonLoading;
  final PageCommand? pageCommand;
  final Place? newPlace;
  final DateTime? newEventDateAndTime;
  final TimeOfDay? newEventStartTime;
  final TimeOfDay? newEventEndTime;
  final String eventDateAndTimeInfo;
  final String endTimeInfo;
  final String startTimeInfo;

  const EditRegionEventState({
    required this.newRegionEventDescription,
    required this.newRegionEventName,
    required this.event,
    required this.isSaveChangesButtonLoading,
    this.pageCommand,
    this.newPlace,
    this.newEventDateAndTime,
    this.newEventStartTime,
    this.newEventEndTime,
    required this.endTimeInfo,
    required this.startTimeInfo,
    required this.eventDateAndTimeInfo,
  });

  @override
  List<Object?> get props => [
        newRegionEventDescription,
        newRegionEventName,
        event,
        isSaveChangesButtonLoading,
        pageCommand,
        newPlace,
        newEventDateAndTime,
        newEventStartTime,
        newEventEndTime,
        endTimeInfo,
        startTimeInfo,
        eventDateAndTimeInfo,
      ];

  EditRegionEventState copyWith({
    String? newRegionEventDescription,
    String? newRegionEventName,
    RegionEventModel? event,
    bool? isSaveChangesButtonLoading,
    PageCommand? pageCommand,
    Place? newPlace,
    DateTime? newEventDateAndTime,
    TimeOfDay? newEventStartTime,
    TimeOfDay? newEventEndTime,
    String? endTimeInfo,
    String? startTimeInfo,
    String? eventDateAndTimeInfo,
  }) =>
      EditRegionEventState(
        newRegionEventDescription: newRegionEventDescription ?? this.newRegionEventDescription,
        newRegionEventName: newRegionEventName ?? this.newRegionEventName,
        event: event ?? this.event,
        isSaveChangesButtonLoading: isSaveChangesButtonLoading ?? this.isSaveChangesButtonLoading,
        pageCommand: pageCommand,
        newPlace: newPlace ?? this.newPlace,
        newEventDateAndTime: newEventDateAndTime ?? this.newEventDateAndTime,
        newEventStartTime: newEventStartTime ?? this.newEventStartTime,
        newEventEndTime: newEventEndTime ?? this.newEventEndTime,
        endTimeInfo: endTimeInfo ?? this.endTimeInfo,
        startTimeInfo: startTimeInfo ?? this.startTimeInfo,
        eventDateAndTimeInfo: eventDateAndTimeInfo ?? this.eventDateAndTimeInfo,
      );

  factory EditRegionEventState.initial(RegionEventModel event) {
    return EditRegionEventState(
      newRegionEventDescription: "",
      newRegionEventName: "",
      event: event,
      isSaveChangesButtonLoading: false,
      eventDateAndTimeInfo: event.formattedCreatedTime,
      endTimeInfo: "${event.formattedEndTime} - Ends",
      startTimeInfo: "${event.formattedStartTime} - Starts",
    );
  }
}
