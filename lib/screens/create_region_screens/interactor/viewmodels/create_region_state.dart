part of 'create_region_bloc.dart';

enum CreateRegionScreen { selectRegion, displayName, regionId, addDescription, selectBackgroundImage, reviewRegion }

class CreateRegionState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final CreateRegionScreen createRegionsScreens;
  final String regionName;
  final String regionDescription;
  final File? file;
  final String? imageUrl;
  final PictureBoxState pictureBoxState;
  final bool isNextButtonLoading;
  final String regionId;
  final String? regionIdErrorMessage;
  final Place? currentPlace;
  final RegionIdStatusIcon regionIdAuthenticationState;
  final bool createImageUrl;

  const CreateRegionState({
    required this.pageState,
    this.pageCommand,
    required this.createRegionsScreens,
    required this.regionName,
    required this.regionDescription,
    this.file,
    this.imageUrl,
    required this.pictureBoxState,
    required this.regionId,
    this.regionIdErrorMessage,
    this.currentPlace,
    required this.regionIdAuthenticationState,
    required this.isNextButtonLoading,
    required this.createImageUrl,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        createRegionsScreens,
        regionName,
        regionDescription,
        file,
    imageUrl,
        pictureBoxState,
        regionId,
        regionIdErrorMessage,
        currentPlace,
        regionIdAuthenticationState,
        isNextButtonLoading,
        createImageUrl
      ];

  CreateRegionState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    CreateRegionScreen? createRegionsScreens,
    String? regionName,
    String? regionDescription,
    File? file,
    String? imageUrl,
    PictureBoxState? pictureBoxState,
    String? regionId,
    String? regionIdErrorMessage,
    Place? currentPlace,
    RegionIdStatusIcon? regionIdAuthenticationState,
    bool? isNextButtonLoading,
    bool? createImageUrl,
  }) =>
      CreateRegionState(
        pageState: pageState ?? this.pageState,
        pageCommand: pageCommand,
        createRegionsScreens: createRegionsScreens ?? this.createRegionsScreens,
        regionName: regionName ?? this.regionName,
        regionDescription: regionDescription ?? this.regionDescription,
        file: file ?? this.file,
        imageUrl: imageUrl ?? this.imageUrl,
        pictureBoxState: pictureBoxState ?? this.pictureBoxState,
        regionId: regionId ?? this.regionId,
        regionIdErrorMessage: regionIdErrorMessage,
        currentPlace: currentPlace ?? this.currentPlace,
        regionIdAuthenticationState: regionIdAuthenticationState ?? this.regionIdAuthenticationState,
        isNextButtonLoading: isNextButtonLoading ?? this.isNextButtonLoading,
        createImageUrl: createImageUrl ?? this.createImageUrl,
      );

  factory CreateRegionState.initial() {
    return const CreateRegionState(
      pageState: PageState.success,
      createRegionsScreens: CreateRegionScreen.selectRegion,
      regionName: "",
      regionDescription: "",
      pictureBoxState: PictureBoxState.pickImage,
      regionId: "",
      regionIdAuthenticationState: RegionIdStatusIcon.loading,
      isNextButtonLoading: false,
      createImageUrl: false,
    );
  }
}
