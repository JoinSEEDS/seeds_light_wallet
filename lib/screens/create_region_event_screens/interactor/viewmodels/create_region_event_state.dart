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
  final DateTime? eventDateAndTime;
  final DateTime? eventDate;
  final TimeOfDay? eventTime;
  final bool isNextButtonLoading;
  final bool createImageUrl;

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
    this.eventDateAndTime,
    this.eventDate,
    this.eventTime,
    required this.isNextButtonLoading,
    required this.createImageUrl,
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
        eventDateAndTime,
        eventDate,
        eventTime,
        isNextButtonLoading,
        createImageUrl,
      ];

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
    DateTime? eventDateAndTime,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    bool? isNextButtonLoading,
    bool? createImageUrl,
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
        imageUrl: imageUrl,
        eventDateAndTime: eventDateAndTime ?? this.eventDateAndTime,
        eventDate: eventDate ?? this.eventDate,
        eventTime: eventTime ?? this.eventTime,
        isNextButtonLoading: isNextButtonLoading ?? this.isNextButtonLoading,
        createImageUrl: createImageUrl ?? this.createImageUrl,
      );

  factory CreateRegionEventState.initial() {
    return const CreateRegionEventState(
      pageState: PageState.success,
      createRegionEventScreen: CreateRegionEventScreen.selectLocation,
      eventDescription: "",
      eventName: "",
      pictureBoxState: PictureBoxState.pickImage,
      isNextButtonLoading: false,
      createImageUrl: false,
    );
  }
}
