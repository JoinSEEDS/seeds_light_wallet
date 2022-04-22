part of 'region_event_details_bloc.dart';

abstract class RegionEventDetailsEvent extends Equatable {
  const RegionEventDetailsEvent();

  @override
  List<Object> get props => [];
}

class OnRegionMapsLinkTapped extends RegionEventDetailsEvent {
  const OnRegionMapsLinkTapped();

  @override
  String toString() => 'OnRegionMapsLinkTapped';
}

class ClearRegionEventPageCommand extends RegionEventDetailsEvent {
  const ClearRegionEventPageCommand();

  @override
  String toString() => 'ClearRegionEventPageCommand';
}
