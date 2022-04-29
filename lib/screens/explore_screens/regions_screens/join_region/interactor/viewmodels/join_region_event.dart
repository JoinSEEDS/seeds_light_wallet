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

class OnCreateRegionTapped extends JoinRegionEvent {
  const OnCreateRegionTapped();

  @override
  String toString() => 'OnCreateRegionTapped';
}

class OnCreateRegionNextTapped extends JoinRegionEvent {
  const OnCreateRegionNextTapped();

  @override
  String toString() => 'OnCreateRegionNextTapped';
}

class ClearJoinRegionPageCommand extends JoinRegionEvent {
  const ClearJoinRegionPageCommand();

  @override
  String toString() => 'ClearJoinRegionPageCommand';
}
