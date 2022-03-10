part of 'region_bloc.dart';

class RegionState extends Equatable {
  final PageState pageState;
  final RegionModel? region;

  const RegionState({
    required this.pageState,
    this.region,
  });

  @override
  List<Object?> get props => [
        pageState,
        region,
      ];

  RegionState copyWith({
    PageState? pageState,
    RegionModel? region,
  }) {
    return RegionState(pageState: pageState ?? this.pageState, region: region ?? this.region);
  }

  factory RegionState.initial() {
    return const RegionState(
      pageState: PageState.initial,
    );
  }
}
