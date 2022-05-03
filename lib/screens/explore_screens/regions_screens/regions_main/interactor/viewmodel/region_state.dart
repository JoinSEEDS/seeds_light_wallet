part of 'region_bloc.dart';

enum TypeOfUsers { member, admin }

class RegionState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final RegionModel? region;
  final bool isBrowseView;
  final TypeOfUsers? userType;

  const RegionState({
    this.pageCommand,
    required this.pageState,
    this.region,
    required this.isBrowseView,
    this.userType,
  });

  @override
  List<Object?> get props => [pageCommand, pageState, region, isBrowseView, userType];

  RegionState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    RegionModel? region,
    bool? isBrowseView,
    TypeOfUsers? userType,
  }) {
    return RegionState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      region: region ?? this.region,
      isBrowseView: isBrowseView ?? this.isBrowseView,
      userType: userType ?? this.userType,
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
