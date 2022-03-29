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
  final DateTime? eventDateTime;

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
    this.eventDateTime,
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
        eventDateTime,
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
    DateTime? eventDateTime,
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
        eventDateTime: eventDateTime ?? this.eventDateTime,
      );

  factory CreateRegionEventState.initial() {
    return const CreateRegionEventState(
      pageState: PageState.success,
      createRegionEventScreen: CreateRegionEventScreen.selectLocation,
      eventDescription: "",
      eventName: "",
      pictureBoxState: PictureBoxState.pickImage,
    );
  }
}
