part of 'region_event_details_bloc.dart';

class RegionEventDetailsState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final RegionEventModel event;
  final bool isUserJoined;

  const RegionEventDetailsState({
    this.pageCommand,
    required this.pageState,
    required this.event,
    required this.isUserJoined,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        isUserJoined,
      ];

  RegionEventDetailsState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    bool? isUserJoined,
  }) {
    return RegionEventDetailsState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      event: event,
      isUserJoined: isUserJoined ?? this.isUserJoined,
    );
  }

  factory RegionEventDetailsState.initial(RegionEventModel event) {
    return RegionEventDetailsState(
      pageState: PageState.initial,
      event: event,
      isUserJoined: event.users.contains(settingsStorage.accountName),
    );
  }
}
