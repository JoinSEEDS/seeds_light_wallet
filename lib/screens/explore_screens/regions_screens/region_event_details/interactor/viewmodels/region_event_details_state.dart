part of 'region_event_details_bloc.dart';

class RegionEventDetailsState extends Equatable {
  final PageCommand? pageCommand;

  const RegionEventDetailsState({this.pageCommand});

  @override
  List<Object?> get props => [pageCommand];
  RegionEventDetailsState copyWith({PageCommand? pageCommand}) {
    return RegionEventDetailsState(pageCommand: pageCommand);
  }

  factory RegionEventDetailsState.initial() => const RegionEventDetailsState();
}
