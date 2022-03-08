part of 'create_region_bloc.dart';

enum CreateRegionScreen { selectRegion, displayName, regionId, addDescription, selectBackgroundImage, reviewRegion }

class CreateRegionState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final CreateRegionScreen createRegionsScreens;
  final File? file;
  final bool isUploadImageNextAvailable;

  const CreateRegionState({
    required this.pageState,
    this.pageCommand,
    required this.createRegionsScreens,
    this.file,
    required this.isUploadImageNextAvailable,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        createRegionsScreens,
        file,
        isUploadImageNextAvailable,
      ];

  CreateRegionState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    CreateRegionScreen? createRegionsScreens,
    String? displayName,
    File? file,
    bool? isUploadImageNextAvailable,
  }) =>
      CreateRegionState(
          pageState: pageState ?? this.pageState,
          pageCommand: pageCommand,
          createRegionsScreens: createRegionsScreens ?? this.createRegionsScreens,
          file: file ?? this.file,
          isUploadImageNextAvailable: isUploadImageNextAvailable ?? this.isUploadImageNextAvailable);

  factory CreateRegionState.initial() {
    return const CreateRegionState(
      pageState: PageState.success,
      createRegionsScreens: CreateRegionScreen.selectRegion,
      isUploadImageNextAvailable: false,
    );
  }
}
