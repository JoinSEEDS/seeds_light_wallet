part of 'region_bloc.dart';

enum TypeOfUsers { member, admin }

class RegionState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final RegionModel? region;
  final bool isBrowseView;
  final TypeOfUsers? userType;
  final bool loadingEvents;

  const RegionState(
      {this.pageCommand,
      required this.pageState,
      this.region,
      required this.isBrowseView,
      this.userType,
      required this.loadingEvents,});

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        region,
        isBrowseView,
        userType,
        loadingEvents,
      ];

  bool get canCreateAnEvent => !isBrowseView || userType == TypeOfUsers.admin;

  RegionState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    RegionModel? region,
    bool? isBrowseView,
    TypeOfUsers? userType,
    bool? loadingEvents,
  }) {
    return RegionState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      region: region ?? this.region,
      isBrowseView: isBrowseView ?? this.isBrowseView,
      userType: userType ?? this.userType,
      loadingEvents: loadingEvents ?? this.loadingEvents,
    );
  }

  factory RegionState.initial(RegionModel? region) {
    return RegionState(
      pageState: PageState.success,
      isBrowseView: region != null,
      region: region,
      loadingEvents: true,
    );
  }
}
