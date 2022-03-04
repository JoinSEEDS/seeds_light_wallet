part of 'create_region_bloc.dart';

enum CreateRegionScreens { selectRegion, displayName, addDescription, selectBackgroundImage, reviewRegion }

class CreateRegionState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final CreateRegionScreens createRegionsScreens;

  const CreateRegionState({
    required this.pageState,
    this.pageCommand,
    required this.createRegionsScreens,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        createRegionsScreens,
      ];

  CreateRegionState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    CreateRegionScreens? createRegionsScreens,
    String? displayName,
  }) =>
      CreateRegionState(
        pageState: pageState ?? this.pageState,
        pageCommand: pageCommand,
        createRegionsScreens: createRegionsScreens ?? this.createRegionsScreens,
      );

  factory CreateRegionState.initial() {
    return const CreateRegionState(
      pageState: PageState.success,
      createRegionsScreens: CreateRegionScreens.selectRegion,
    );
  }
}
