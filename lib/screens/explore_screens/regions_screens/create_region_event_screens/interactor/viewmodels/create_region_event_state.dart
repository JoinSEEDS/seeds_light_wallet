part of 'create_region_event_bloc.dart';

enum CreateRegionEventScreen {
  selectLocation,
  displayName,
  addDescription,
  selectBackgroundImage,
  reviewAndPublish,
  choseDataAndTime,
}

class CreateRegionEventState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final CreateRegionEventScreen createRegionEventScreen;
  final String eventDescription;
  final String eventName;
  final Place? currentPlace;
  final File? file;
  final PictureBoxState pictureBoxState;
  final String? imageUrl;
  final DateTime? eventStartDate;
  final DateTime? eventEndDate;
  final TimeOfDay? eventStartTime;
  final TimeOfDay? eventEndTime;
  final bool isNextButtonLoading;
  final bool createImageUrl;
  final RegionModel region;
  final bool isPublishEventButtonLoading;

  const CreateRegionEventState({
    required this.pageState,
    this.pageCommand,
    required this.createRegionEventScreen,
    required this.eventDescription,
    required this.eventName,
    this.currentPlace,
    this.file,
    required this.pictureBoxState,
    this.imageUrl,
    this.eventStartDate,
    this.eventEndDate,
    this.eventStartTime,
    this.eventEndTime,
    required this.isNextButtonLoading,
    required this.createImageUrl,
    required this.region,
    required this.isPublishEventButtonLoading,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        createRegionEventScreen,
        eventDescription,
        eventName,
        currentPlace,
        file,
        pictureBoxState,
        imageUrl,
        eventStartDate,
        eventEndDate,
        eventStartTime,
        eventEndTime,
        isNextButtonLoading,
        createImageUrl,
        region,
        isPublishEventButtonLoading,
      ];

  bool get isDateTimeNextButtonEnabled =>
      eventStartDate != null && eventEndDate != null && eventStartTime != null && eventEndTime != null;

  String get startDateAndTimeFormatted =>
      eventStartDate != null ? DateFormat('EEEE, MMM d, y - h:mm a').format(eventStartDate!) : "";

  String get endDateAndTimeFormatted =>
      eventEndDate != null ? DateFormat('EEEE, MMM d, y - h:mm a').format(eventEndDate!) : "";

  CreateRegionEventState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    CreateRegionEventScreen? createRegionEventScreen,
    String? eventDescription,
    String? eventName,
    Place? currentPlace,
    File? file,
    PictureBoxState? pictureBoxState,
    String? imageUrl,
    DateTime? eventStartDate,
    DateTime? eventEndDate,
    TimeOfDay? eventStartTime,
    TimeOfDay? eventEndTime,
    bool? isNextButtonLoading,
    bool? createImageUrl,
    RegionModel? region,
    bool? isPublishEventButtonLoading,
  }) =>
      CreateRegionEventState(
        pageState: pageState ?? this.pageState,
        pageCommand: pageCommand,
        createRegionEventScreen: createRegionEventScreen ?? this.createRegionEventScreen,
        eventDescription: eventDescription ?? this.eventDescription,
        eventName: eventName ?? this.eventName,
        currentPlace: currentPlace ?? this.currentPlace,
        file: file ?? this.file,
        pictureBoxState: pictureBoxState ?? this.pictureBoxState,
        imageUrl: imageUrl ?? this.imageUrl,
        eventStartDate: eventStartDate ?? this.eventStartDate,
        eventEndDate: eventEndDate ?? this.eventEndDate,
        eventStartTime: eventStartTime ?? this.eventStartTime,
        eventEndTime: eventEndTime ?? this.eventEndTime,
        isNextButtonLoading: isNextButtonLoading ?? this.isNextButtonLoading,
        createImageUrl: createImageUrl ?? this.createImageUrl,
        region: region ?? this.region,
        isPublishEventButtonLoading: isPublishEventButtonLoading ?? this.isPublishEventButtonLoading,
      );

  factory CreateRegionEventState.initial(RegionModel region) {
    return CreateRegionEventState(
      pageState: PageState.success,
      createRegionEventScreen: CreateRegionEventScreen.selectLocation,
      eventDescription: "",
      eventName: "",
      pictureBoxState: PictureBoxState.pickImage,
      isNextButtonLoading: false,
      createImageUrl: false,
      region: region,
      isPublishEventButtonLoading: false,
    );
  }
}
