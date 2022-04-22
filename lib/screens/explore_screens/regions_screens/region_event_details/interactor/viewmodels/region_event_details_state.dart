part of 'region_event_details_bloc.dart';

class RegionEventDetailsState extends Equatable {
  final RegionEventModel event;
  final PageCommand? pageCommand;

  const RegionEventDetailsState({this.pageCommand, required this.event});

  @override
  List<Object?> get props => [event, pageCommand];

  RegionEventDetailsState copyWith({RegionEventModel? event, PageCommand? pageCommand}) {
    return RegionEventDetailsState(event: event ?? this.event, pageCommand: pageCommand);
  }

  factory RegionEventDetailsState.initial(RegionEventModel event) {
    return RegionEventDetailsState(
      event: event,
    );
  }
}
