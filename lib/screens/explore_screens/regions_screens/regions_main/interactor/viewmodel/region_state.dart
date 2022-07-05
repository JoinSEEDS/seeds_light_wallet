part of 'region_bloc.dart';

enum TypeOfUsers { member, admin }

class RegionState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final RegionModel? region;
  final bool isBrowseView;
  final TypeOfUsers? userType;
  final String? deepLinkRegionId;
  final bool loadingEvents;

  const RegionState({
    this.pageCommand,
    required this.pageState,
    this.region,
    required this.isBrowseView,
    this.userType,
    this.deepLinkRegionId,
    required this.loadingEvents,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        region,
        isBrowseView,
        userType,
        deepLinkRegionId,
        loadingEvents,
      ];

  bool get canCreateAnEvent => !isBrowseView || userType == TypeOfUsers.admin;

  RegionState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    RegionModel? region,
    bool? isBrowseView,
    TypeOfUsers? userType,
    String? deepLinkRegionId,
    bool? loadingEvents,
  }) {
    return RegionState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      region: region ?? this.region,
      isBrowseView: isBrowseView ?? this.isBrowseView,
      userType: userType ?? this.userType,
      deepLinkRegionId: deepLinkRegionId ?? this.deepLinkRegionId,
      loadingEvents: loadingEvents ?? this.loadingEvents,
    );
  }

  factory RegionState.initial(RegionModel? region, String? deepLinkRegionId) {
    return RegionState(
      pageState: PageState.success,
      isBrowseView: region != null,
      region: region,
      deepLinkRegionId: deepLinkRegionId,
      loadingEvents: true,
    );
  }
}
