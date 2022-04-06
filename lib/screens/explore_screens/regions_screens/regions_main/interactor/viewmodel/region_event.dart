part of 'region_bloc.dart';

abstract class RegionEvent extends Equatable {
  const RegionEvent();

  @override
  List<Object?> get props => [];
}

class OnRegionMounted extends RegionEvent {
  const OnRegionMounted();
  @override
  String toString() => 'OnRegionMounted';
}

class OnJoinRegionButtonPressed extends RegionEvent {
  const OnJoinRegionButtonPressed();
  @override
  String toString() => 'OnJoinRegionButtonPressed';
}

class OnLeaveRegionButtonPressed extends RegionEvent {
  const OnLeaveRegionButtonPressed();
  @override
  String toString() => 'OnLeaveRegionButtonPressed';
}
