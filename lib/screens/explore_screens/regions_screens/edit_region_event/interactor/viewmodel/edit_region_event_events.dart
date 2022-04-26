part of 'edit_region_event_bloc.dart';

abstract class EditRegionEventEvents extends Equatable {
  const EditRegionEventEvents();

  @override
  List<Object?> get props => [];
}

class ClearEditRegionEventPageCommand extends EditRegionEventEvents {
  const ClearEditRegionEventPageCommand();

  @override
  String toString() => 'ClearEditRegionEventPageCommand';
}

class OnUpdateMapLocation extends EditRegionEventEvents {
  final Place place;

  const OnUpdateMapLocation(this.place);

  @override
  String toString() => 'OnUpdateMapLocation { Place: $place}';
}