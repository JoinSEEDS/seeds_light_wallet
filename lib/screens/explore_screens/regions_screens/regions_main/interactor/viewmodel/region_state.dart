part of 'region_bloc.dart';

class RegionState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final RegionModel? region;
  final bool isBrowseView;

  const RegionState({
    this.pageCommand,
    required this.pageState,
    this.region,
    required this.isBrowseView,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        region,
        isBrowseView,
      ];

  RegionState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    RegionModel? region,
    bool? isBrowseView,
  }) {
    return RegionState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      region: region ?? this.region,
      isBrowseView: isBrowseView ?? this.isBrowseView,
    );
  }

  factory RegionState.initial(RegionModel? region) {
    return RegionState(
      pageState: PageState.initial,
      isBrowseView: region != null,
      region: region,
    );
  }
}
