part of 'create_region_event_bloc.dart';

enum CreateRegionEventScreen {
  selectLocation,
  displayName,
  addDescription,
  selectBackgroundImage,
  reviewAndPublish,
}

class CreateRegionEventState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final CreateRegionEventScreen createRegionEventScreen;
  final String eventDescription;
  final String eventName;
  final File? file;
  final PictureBoxState pictureBoxState;
  final String? imageUrl;

  const CreateRegionEventState({
    required this.pageState,
    this.pageCommand,
    required this.createRegionEventScreen,
    required this.eventDescription,
    required this.eventName,
    this.file,
    required this.pictureBoxState,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        createRegionEventScreen,
        eventDescription,
        eventName,
        file,
        pictureBoxState,
        imageUrl,
      ];

  CreateRegionEventState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    CreateRegionEventScreen? createRegionEventScreen,
    String? eventDescription,
    String? eventName,
    File? file,
    PictureBoxState? pictureBoxState,
    String? imageUrl,
  }) =>
      CreateRegionEventState(
        pageState: pageState ?? this.pageState,
        pageCommand: pageCommand,
        createRegionEventScreen: createRegionEventScreen ?? this.createRegionEventScreen,
        eventDescription: eventDescription ?? this.eventDescription,
        eventName: eventName ?? this.eventName,
        file: file ?? this.file,
        pictureBoxState: pictureBoxState ?? this.pictureBoxState,
        imageUrl: imageUrl,
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
