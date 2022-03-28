part of 'region_bloc.dart';

abstract class RegionEvent extends Equatable {
  const RegionEvent();

  @override
  List<Object?> get props => [];
}

class OnJoinRegionButtonPressed extends RegionEvent {
  final String regionId;
  const OnJoinRegionButtonPressed(this.regionId);
  @override
  String toString() => 'OnJoinRegionButtonPressed';
}
