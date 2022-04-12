part of 'region_bloc.dart';

class RegionState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final RegionModel? region;
  final bool isBrowseView;
  final bool isSaveChangesButtonLoading;
  final File? newImageFile;
  final PictureBoxState pictureBoxState;

  const RegionState({
    this.pageCommand,
    required this.pageState,
    this.region,
    required this.isBrowseView,
    required this.isSaveChangesButtonLoading,
    this.newImageFile,
    required this.pictureBoxState,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        region,
        isBrowseView,
        isSaveChangesButtonLoading,
        newImageFile,
        pictureBoxState,
      ];

  RegionState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    RegionModel? region,
    bool? isBrowseView,
    bool? isSaveChangesButtonLoading,
    File? newImageFile,
    PictureBoxState? pictureBoxState,
  }) {
    return RegionState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      region: region ?? this.region,
      isBrowseView: isBrowseView ?? this.isBrowseView,
      isSaveChangesButtonLoading: isSaveChangesButtonLoading ?? this.isSaveChangesButtonLoading,
      newImageFile: newImageFile ?? this.newImageFile,
      pictureBoxState: pictureBoxState ?? this.pictureBoxState,
    );
  }

  factory RegionState.initial(RegionModel? region) {
    return RegionState(
        pageState: PageState.initial,
        isBrowseView: region != null,
        region: region,
        isSaveChangesButtonLoading: false,
        pictureBoxState: PictureBoxState.pickImage);
  }
}
