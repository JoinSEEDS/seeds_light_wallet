part of 'region_event_card_bloc.dart';

abstract class RegionEventCardEvent extends Equatable {
  const RegionEventCardEvent();

  @override
  List<Object> get props => [];
}

class OnLoadRegionEventMembers extends RegionEventCardEvent {
  final List<String> eventUsers;

  const OnLoadRegionEventMembers(this.eventUsers);

  @override
  String toString() => 'OnLoadRegionEventMembers';
}
