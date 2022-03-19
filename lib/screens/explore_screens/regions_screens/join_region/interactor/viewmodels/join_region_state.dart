part of 'join_region_bloc.dart';

class JoinRegionState extends Equatable {
  final PageState pageState;
  final List<RegionModel> regions;
  final Place? currentPlace;

  const JoinRegionState({
    required this.pageState,
    required this.regions,
    this.currentPlace,
  });

  @override
  List<Object?> get props => [pageState, regions, currentPlace];

  JoinRegionState copyWith({
    PageState? pageState,
    List<RegionModel>? regions,
    Place? currentPlace,
  }) {
    return JoinRegionState(
      pageState: pageState ?? this.pageState,
      regions: regions ?? this.regions,
      currentPlace: currentPlace ?? this.currentPlace,
    );
  }

  factory JoinRegionState.initial() {
    return const JoinRegionState(pageState: PageState.initial, regions: []);
  }
}
