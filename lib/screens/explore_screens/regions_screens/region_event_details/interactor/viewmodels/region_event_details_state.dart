part of 'region_event_details_bloc.dart';

class RegionEventDetailsState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final RegionEventModel event;
  final bool isJoinLeaveButtonLoading;
  final bool isUserJoined;
  final bool isBrowseView;

  const RegionEventDetailsState({
    this.pageCommand,
    required this.pageState,
    required this.event,
    required this.isJoinLeaveButtonLoading,
    required this.isUserJoined,
    required this.isBrowseView,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        event,
        isJoinLeaveButtonLoading,
        isUserJoined,
        isBrowseView,
      ];

  bool get isEventCreatorAccount => settingsStorage.accountName == event.creatorAccount;

  RegionEventDetailsState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    RegionEventModel? event,
    bool? isJoinLeaveButtonLoading,
    bool? isUserJoined,
    bool? isBrowseView,
  }) {
    return RegionEventDetailsState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      event: event ?? this.event,
      isJoinLeaveButtonLoading: isJoinLeaveButtonLoading ?? this.isJoinLeaveButtonLoading,
      isUserJoined: isUserJoined ?? this.isUserJoined,
      isBrowseView: isBrowseView ?? this.isBrowseView,
    );
  }

  factory RegionEventDetailsState.initial(RegionEventModel event) {
    return RegionEventDetailsState(
      pageState: PageState.initial,
      event: event,
      isJoinLeaveButtonLoading: false,
      isUserJoined: event.users.contains(settingsStorage.accountName),
      isBrowseView: true,
    );
  }
}
