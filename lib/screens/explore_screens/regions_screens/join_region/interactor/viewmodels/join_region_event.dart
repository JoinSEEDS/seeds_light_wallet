part of 'join_region_bloc.dart';

abstract class JoinRegionEvent extends Equatable {
  const JoinRegionEvent();

  @override
  List<Object> get props => [];
}

class OnLoadRegions extends JoinRegionEvent {
  const OnLoadRegions();
  @override
  String toString() => 'OnLoadRegions';
}

class OnUpdateMapLocation extends JoinRegionEvent {
  final Place place;
  const OnUpdateMapLocation(this.place);
  @override
  String toString() => 'OnUpdateMapLocation';
}

class OnRegionResultSelected extends JoinRegionEvent {
  final String regionId;
  const OnRegionResultSelected(this.regionId);
  @override
  String toString() => 'OnRegionResultSelected';
}
