part of 'create_region_bloc.dart';

enum CreateRegionScreen { selectRegion, displayName, regionId, addDescription, selectBackgroundImage, reviewRegion }

class CreateRegionState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final CreateRegionScreen createRegionsScreens;
  final String regionName;
  final bool isRegionNameNextAvailable;
  final String regionDescription;
  final bool isRegionDescriptionNextAvailable;
  final File? file;
  final bool isUploadImageNextAvailable;
  final String? imageUrl;
  final PictureBoxState pictureBoxState;

  const CreateRegionState({
    required this.pageState,
    this.pageCommand,
    required this.createRegionsScreens,
    required this.regionName,
    required this.isRegionNameNextAvailable,
    required this.regionDescription,
    required this.isRegionDescriptionNextAvailable,
    this.file,
    required this.isUploadImageNextAvailable,
    this.imageUrl,
    required this.pictureBoxState,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        createRegionsScreens,
        regionName,
        isRegionNameNextAvailable,
        regionDescription,
        isRegionDescriptionNextAvailable,
        file,
        isUploadImageNextAvailable,
        imageUrl,
        pictureBoxState,
      ];

  CreateRegionState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    CreateRegionScreen? createRegionsScreens,
    String? regionName,
    bool? isRegionNameNextAvailable,
    String? regionDescription,
    bool? isRegionDescriptionNextAvailable,
    File? file,
    bool? isUploadImageNextAvailable,
    String? imageUrl,
    PictureBoxState? pictureBoxState,
  }) =>
      CreateRegionState(
          pageState: pageState ?? this.pageState,
          pageCommand: pageCommand,
          createRegionsScreens: createRegionsScreens ?? this.createRegionsScreens,
          regionName: regionName ?? this.regionName,
          isRegionNameNextAvailable: isRegionNameNextAvailable ?? this.isRegionNameNextAvailable,
          regionDescription: regionDescription ?? this.regionDescription,
          isRegionDescriptionNextAvailable: isRegionDescriptionNextAvailable ?? this.isRegionDescriptionNextAvailable,
          file: file ?? this.file,
          isUploadImageNextAvailable: isUploadImageNextAvailable ?? this.isUploadImageNextAvailable,
          imageUrl: imageUrl,
          pictureBoxState: pictureBoxState ?? this.pictureBoxState);

  factory CreateRegionState.initial() {
    return const CreateRegionState(
      pageState: PageState.success,
      createRegionsScreens: CreateRegionScreen.selectRegion,
      regionName: "",
      isRegionNameNextAvailable: false,
      regionDescription: "",
      isRegionDescriptionNextAvailable: false,
      isUploadImageNextAvailable: false,
      pictureBoxState: PictureBoxState.pickImage,
    );
  }
}
