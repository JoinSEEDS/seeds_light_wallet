part of 'edit_region_bloc.dart';

class EditRegionState extends Equatable {
  final String newRegionDescription;
  final RegionModel region;
  final bool isSaveChangesButtonEnable;
  final bool isSaveChangesButtonLoading;
  final PageCommand? pageCommand;
  final File? file;
  final PictureBoxState pictureBoxState;
  final String? imageUrl;

  const EditRegionState({
    required this.newRegionDescription,
    required this.region,
    required this.isSaveChangesButtonEnable,
    required this.isSaveChangesButtonLoading,
    this.pageCommand,
    this.file,
    required this.pictureBoxState,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        newRegionDescription,
        region,
        isSaveChangesButtonEnable,
        isSaveChangesButtonLoading,
        pageCommand,
        file,
        pictureBoxState,
        imageUrl,
      ];

  bool get shouldShowReplaceButton => file != null && !isSaveChangesButtonLoading;

  EditRegionState copyWith({
    String? newRegionDescription,
    RegionModel? region,
    bool? isSaveChangesButtonEnable,
    bool? isSaveChangesButtonLoading,
    PageCommand? pageCommand,
    File? file,
    PictureBoxState? pictureBoxState,
    String? imageUrl,
  }) =>
      EditRegionState(
        newRegionDescription: newRegionDescription ?? this.newRegionDescription,
        region: region ?? this.region,
        isSaveChangesButtonEnable: isSaveChangesButtonEnable ?? this.isSaveChangesButtonEnable,
        isSaveChangesButtonLoading: isSaveChangesButtonLoading ?? this.isSaveChangesButtonLoading,
        pageCommand: pageCommand,
        file: file ?? this.file,
        pictureBoxState: pictureBoxState ?? this.pictureBoxState,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory EditRegionState.initial(RegionModel region) {
    return EditRegionState(
      newRegionDescription: "",
      region: region,
      isSaveChangesButtonEnable: false,
      isSaveChangesButtonLoading: false,
      pictureBoxState: PictureBoxState.pickImage,
    );
  }
}
