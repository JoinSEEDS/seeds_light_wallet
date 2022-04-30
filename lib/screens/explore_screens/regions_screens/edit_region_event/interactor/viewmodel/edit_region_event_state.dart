part of 'edit_region_event_bloc.dart';

class EditRegionEventState extends Equatable {
  final String newRegionEventDescription;
  final String newRegionEventName;
  final RegionEventModel event;
  final bool isSaveChangesButtonLoading;
  final bool isSaveChangesButtonEnable;
  final bool isNewNameNotEmpty;
  final bool isNewDescriptionNotEmpty;
  final PageCommand? pageCommand;
  final Place? newPlace;
  final DateTime? newEventDateAndTime;
  final TimeOfDay? newEventStartTime;
  final TimeOfDay? newEventEndTime;
  final String eventDateAndTimeInfo;
  final String endTimeInfo;
  final String startTimeInfo;
  final File? file;
  final PictureBoxState pictureBoxState;

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
    this.file,
    required this.pictureBoxState,
    required this.isSaveChangesButtonEnable,
    required this.isNewNameNotEmpty,
    required this.isNewDescriptionNotEmpty,
  });

  @override
  List<Object?> get props => [
        newRegionEventDescription,
        newRegionEventName,
        event,
        isSaveChangesButtonLoading,
        isSaveChangesButtonEnable,
        isNewNameNotEmpty,
        isNewDescriptionNotEmpty,
        pageCommand,
        newPlace,
        newEventDateAndTime,
        newEventStartTime,
        newEventEndTime,
        endTimeInfo,
        startTimeInfo,
        eventDateAndTimeInfo,
        file,
        pictureBoxState,
      ];

  EditRegionEventState copyWith({
    String? newRegionEventDescription,
    String? newRegionEventName,
    RegionEventModel? event,
    bool? isSaveChangesButtonLoading,
    bool? isSaveChangesButtonEnable,
    bool? isNewNameNotEmpty,
    bool? isNewDescriptionNotEmpty,
    PageCommand? pageCommand,
    Place? newPlace,
    DateTime? newEventDateAndTime,
    TimeOfDay? newEventStartTime,
    TimeOfDay? newEventEndTime,
    String? endTimeInfo,
    String? startTimeInfo,
    String? eventDateAndTimeInfo,
    File? file,
    PictureBoxState? pictureBoxState,
  }) =>
      EditRegionEventState(
        newRegionEventDescription: newRegionEventDescription ?? this.newRegionEventDescription,
        newRegionEventName: newRegionEventName ?? this.newRegionEventName,
        event: event ?? this.event,
        isSaveChangesButtonLoading: isSaveChangesButtonLoading ?? this.isSaveChangesButtonLoading,
        isSaveChangesButtonEnable: isSaveChangesButtonEnable ?? this.isSaveChangesButtonEnable,
        isNewNameNotEmpty: isNewNameNotEmpty ?? this.isNewNameNotEmpty,
        isNewDescriptionNotEmpty: isNewDescriptionNotEmpty ?? this.isNewDescriptionNotEmpty,
        pageCommand: pageCommand,
        newPlace: newPlace ?? this.newPlace,
        newEventDateAndTime: newEventDateAndTime ?? this.newEventDateAndTime,
        newEventStartTime: newEventStartTime ?? this.newEventStartTime,
        newEventEndTime: newEventEndTime ?? this.newEventEndTime,
        endTimeInfo: endTimeInfo ?? this.endTimeInfo,
        startTimeInfo: startTimeInfo ?? this.startTimeInfo,
        eventDateAndTimeInfo: eventDateAndTimeInfo ?? this.eventDateAndTimeInfo,
        file: file ?? this.file,
        pictureBoxState: pictureBoxState ?? this.pictureBoxState,
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
      pictureBoxState: PictureBoxState.pickImage,
      isSaveChangesButtonEnable: false,
      isNewDescriptionNotEmpty: true,
      isNewNameNotEmpty: true,
    );
  }
}
