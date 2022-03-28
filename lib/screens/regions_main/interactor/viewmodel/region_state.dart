part of 'region_bloc.dart';

class RegionState extends Equatable {
  final PageState pageState;
  final RegionModel? region;
  final bool isBrowseView;

  const RegionState({
    required this.pageState,
    this.region,
    required this.isBrowseView,
  });

  @override
  List<Object?> get props => [
        pageState,
        region,
        isBrowseView,
      ];

  RegionState copyWith({
    PageState? pageState,
    RegionModel? region,
    bool? isBrowseView,
  }) {
    return RegionState(
      pageState: pageState ?? this.pageState,
      region: region ?? this.region,
      isBrowseView: isBrowseView ?? this.isBrowseView,
    );
  }

  factory RegionState.initial(bool isBrowseView) {
    return RegionState(
      pageState: PageState.initial,
      isBrowseView: isBrowseView,
    );
  }
}
