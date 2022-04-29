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
      );

  factory EditRegionEventState.initial(RegionEventModel event) {
    return EditRegionEventState(
      newRegionEventDescription: "",
      newRegionEventName: "",
      event: event,
      isSaveChangesButtonLoading: false,
    );
  }
}
