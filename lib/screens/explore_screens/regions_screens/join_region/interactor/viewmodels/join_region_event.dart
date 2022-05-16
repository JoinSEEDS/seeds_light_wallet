part of 'join_region_bloc.dart';

abstract class JoinRegionEvent extends Equatable {
  const JoinRegionEvent();

  @override
  List<Object> get props => [];
}

class OnJoinRegionMounted extends JoinRegionEvent {
  const OnJoinRegionMounted();

  @override
  String toString() => 'OnJoinRegionMounted';
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

class OnRegionsResultsChanged extends JoinRegionEvent {
  final bool isEmpty;
  const OnRegionsResultsChanged(this.isEmpty);

  @override
  String toString() => 'OnRegionsResultsChanged';
}
