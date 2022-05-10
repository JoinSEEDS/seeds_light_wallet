part of 'edit_region_event_bloc.dart';

class EditRegionEventState extends Equatable {
  final String? newRegionEventDescription;
  final String? newRegionEventName;
  final RegionEventModel event;
  final bool isSaveChangesButtonLoading;
  final bool isSaveChangesButtonEnable;
  final bool isNewNameNotEmpty;
  final bool isNewDescriptionNotEmpty;
  final PageCommand? pageCommand;
  final Place? newPlace;
  final DateTime eventStartDate;
  final DateTime eventEndDate;
  final TimeOfDay eventStartTime;
  final TimeOfDay eventEndTime;
  final File? file;
  final PictureBoxState pictureBoxState;
  final String? imageUrl;

  const EditRegionEventState({
    this.newRegionEventDescription,
    this.newRegionEventName,
    required this.event,
    required this.isSaveChangesButtonLoading,
    this.pageCommand,
    this.newPlace,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.eventStartTime,
    required this.eventEndTime,
    this.file,
    required this.pictureBoxState,
    required this.isSaveChangesButtonEnable,
    required this.isNewNameNotEmpty,
    required this.isNewDescriptionNotEmpty,
    this.imageUrl,
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
        eventStartDate,
        eventEndDate,
        eventStartTime,
        eventEndTime,
        file,
        pictureBoxState,
        imageUrl,
      ];

  String get startDateAndTimeFormatted => DateFormat('EEEE, MMM d, y').format(eventStartDate);

  String get endDateAndTimeFormatted => DateFormat('EEEE, MMM d, y').format(eventEndDate);

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
    DateTime? eventStartDate,
    DateTime? eventEndDate,
    TimeOfDay? eventStartTime,
    TimeOfDay? eventEndTime,
    File? file,
    PictureBoxState? pictureBoxState,
    String? imageUrl,
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
        eventStartDate: eventStartDate ?? this.eventStartDate,
        eventEndDate: eventEndDate ?? this.eventEndDate,
        eventStartTime: eventStartTime ?? this.eventStartTime,
        eventEndTime: eventEndTime ?? this.eventEndTime,
        file: file ?? this.file,
        pictureBoxState: pictureBoxState ?? this.pictureBoxState,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory EditRegionEventState.initial(RegionEventModel event) {
    return EditRegionEventState(
      event: event,
      eventStartDate: event.eventStartTime.toDate(),
      eventEndDate: event.eventEndTime.toDate(),
      eventStartTime: TimeOfDay(hour: event.eventStartTime.toDate().hour, minute: event.eventStartTime.toDate().minute),
      eventEndTime: TimeOfDay(hour: event.eventEndTime.toDate().hour, minute: event.eventEndTime.toDate().minute),
      isSaveChangesButtonLoading: false,
      pictureBoxState: PictureBoxState.pickImage,
      isSaveChangesButtonEnable: false,
      isNewDescriptionNotEmpty: true,
      isNewNameNotEmpty: true,
    );
  }
}
