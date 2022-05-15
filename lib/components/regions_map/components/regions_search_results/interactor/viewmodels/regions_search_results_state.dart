part of 'regions_search_results_bloc.dart';

class RegionsSearchResultsState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final List<RegionModel> regions;
  final List<RegionModel> nearbyRegions;
  final Place? currentPlace;

  const RegionsSearchResultsState({
    this.pageCommand,
    required this.pageState,
    required this.regions,
    required this.nearbyRegions,
    this.currentPlace,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        regions,
        nearbyRegions,
        currentPlace,
      ];

  RegionsSearchResultsState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    List<RegionModel>? regions,
    List<RegionModel>? nearbyRegions,
    Place? currentPlace,
  }) {
    return RegionsSearchResultsState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      regions: regions ?? this.regions,
      nearbyRegions: nearbyRegions ?? this.nearbyRegions,
      currentPlace: currentPlace ?? this.currentPlace,
    );
  }

  factory RegionsSearchResultsState.initial(List<RegionModel> regions) {
    return RegionsSearchResultsState(pageState: PageState.initial, regions: regions, nearbyRegions: []);
  }
}
