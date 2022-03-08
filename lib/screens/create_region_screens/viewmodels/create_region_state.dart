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

  const CreateRegionState({
    required this.pageState,
    this.pageCommand,
    required this.createRegionsScreens,
    required this.regionName,
    required this.isRegionNameNextAvailable,
    required this.regionDescription,
    required this.isRegionDescriptionNextAvailable,
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
      ];

  CreateRegionState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    CreateRegionScreen? createRegionsScreens,
    String? regionName,
    bool? isRegionNameNextAvailable,
    String? regionDescription,
    bool? isRegionDescriptionNextAvailable,
  }) =>
      CreateRegionState(
        pageState: pageState ?? this.pageState,
        pageCommand: pageCommand,
        createRegionsScreens: createRegionsScreens ?? this.createRegionsScreens,
        regionName: regionName ?? this.regionName,
        isRegionNameNextAvailable: isRegionNameNextAvailable ?? this.isRegionNameNextAvailable,
        regionDescription: regionDescription ?? this.regionDescription,
        isRegionDescriptionNextAvailable: isRegionDescriptionNextAvailable ?? this.isRegionDescriptionNextAvailable,
      );

  factory CreateRegionState.initial() {
    return const CreateRegionState(
      pageState: PageState.success,
      createRegionsScreens: CreateRegionScreen.selectRegion,
      regionName: "",
      isRegionNameNextAvailable: false,
      regionDescription: "",
      isRegionDescriptionNextAvailable: false,
    );
  }
}
