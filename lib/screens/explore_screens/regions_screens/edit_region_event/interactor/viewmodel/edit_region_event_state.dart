part of 'edit_region_event_bloc.dart';

class EditRegionEventState extends Equatable {
  final String newRegionEventDescription;
  final String newRegionEventName;
  final RegionEventModel event;
  final bool isSaveChangesButtonLoading;
  final PageCommand? pageCommand;
  final File? file;
  final PictureBoxState pictureBoxState;

  const EditRegionEventState({
    required this.newRegionEventDescription,
    required this.newRegionEventName,
    required this.event,
    required this.isSaveChangesButtonLoading,
    this.pageCommand,
    this.file,
    required this.pictureBoxState,
  });

  @override
  List<Object?> get props => [
        newRegionEventDescription,
        newRegionEventName,
        event,
        isSaveChangesButtonLoading,
        pageCommand,
        file,
        pictureBoxState,
      ];

  EditRegionEventState copyWith({
    String? newRegionEventDescription,
    String? newRegionEventName,
    RegionEventModel? event,
    bool? isSaveChangesButtonLoading,
    PageCommand? pageCommand,
    File? file,
    PictureBoxState? pictureBoxState,
  }) =>
      EditRegionEventState(
        newRegionEventDescription: newRegionEventDescription ?? this.newRegionEventDescription,
        newRegionEventName: newRegionEventName ?? this.newRegionEventName,
        event: event ?? this.event,
        isSaveChangesButtonLoading: isSaveChangesButtonLoading ?? this.isSaveChangesButtonLoading,
        pageCommand: pageCommand,
        file: file ?? this.file,
        pictureBoxState: pictureBoxState ?? this.pictureBoxState,
      );

  factory EditRegionEventState.initial(RegionEventModel event) {
    return EditRegionEventState(
      newRegionEventDescription: "",
      newRegionEventName: "",
      event: event,
      isSaveChangesButtonLoading: false,
      pictureBoxState: PictureBoxState.pickImage,
    );
  }
}
