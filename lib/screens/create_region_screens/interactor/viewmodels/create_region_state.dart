part of 'create_region_bloc.dart';

enum CreateRegionScreen { selectRegion, displayName, regionId, addDescription, selectBackgroundImage, reviewRegion }

class CreateRegionState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final CreateRegionScreen createRegionsScreens;
  final String regionName;
  final bool isRegionNameNextButtonEnable;
  final String regionDescription;
  final bool isRegionDescriptionNextButtonEnable;
  final File? file;
  final bool isUploadImageNextButtonEnable;
  final String? imageUrl;
  final PictureBoxState pictureBoxState;
  final String regionId;
  final bool isRegionIdNextButtonEnable;

  const CreateRegionState({
    required this.pageState,
    this.pageCommand,
    required this.createRegionsScreens,
    required this.regionName,
    required this.isRegionNameNextButtonEnable,
    required this.regionDescription,
    required this.isRegionDescriptionNextButtonEnable,
    this.file,
    required this.isUploadImageNextButtonEnable,
    this.imageUrl,
    required this.pictureBoxState,
    required this.isRegionIdNextButtonEnable,
    required this.regionId,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        createRegionsScreens,
        regionName,
        isRegionNameNextButtonEnable,
        regionDescription,
        isRegionDescriptionNextButtonEnable,
        file,
        isUploadImageNextButtonEnable,
        imageUrl,
        pictureBoxState,
        isRegionIdNextButtonEnable,
        regionId,
      ];

  CreateRegionState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    CreateRegionScreen? createRegionsScreens,
    String? regionName,
    bool? isRegionNameNextButtonEnable,
    String? regionDescription,
    bool? isRegionDescriptionNextButtonEnable,
    File? file,
    bool? isUploadImageNextButtonEnable,
    String? imageUrl,
    PictureBoxState? pictureBoxState,
    bool? isRegionIdNextButtonEnable,
    String? regionId,
  }) =>
      CreateRegionState(
        pageState: pageState ?? this.pageState,
        pageCommand: pageCommand,
        createRegionsScreens: createRegionsScreens ?? this.createRegionsScreens,
        regionName: regionName ?? this.regionName,
        isRegionNameNextButtonEnable: isRegionNameNextButtonEnable ?? this.isRegionNameNextButtonEnable,
        regionDescription: regionDescription ?? this.regionDescription,
        isRegionDescriptionNextButtonEnable:
            isRegionDescriptionNextButtonEnable ?? this.isRegionDescriptionNextButtonEnable,
        file: file ?? this.file,
        isUploadImageNextButtonEnable: isUploadImageNextButtonEnable ?? this.isUploadImageNextButtonEnable,
        imageUrl: imageUrl,
        pictureBoxState: pictureBoxState ?? this.pictureBoxState,
        isRegionIdNextButtonEnable: isRegionIdNextButtonEnable ?? this.isRegionIdNextButtonEnable,
        regionId: regionId ?? this.regionId,
      );

  factory CreateRegionState.initial() {
    return const CreateRegionState(
      pageState: PageState.success,
      createRegionsScreens: CreateRegionScreen.selectRegion,
      regionName: "",
      isRegionNameNextButtonEnable: false,
      regionDescription: "",
      isRegionDescriptionNextButtonEnable: false,
      isUploadImageNextButtonEnable: false,
      pictureBoxState: PictureBoxState.pickImage,
      isRegionIdNextButtonEnable: false,
      regionId: "",
    );
  }
}
