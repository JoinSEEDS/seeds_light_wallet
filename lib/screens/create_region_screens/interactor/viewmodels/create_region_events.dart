part of 'create_region_bloc.dart';

abstract class CreateRegionEvent extends Equatable {
  const CreateRegionEvent();

  @override
  List<Object?> get props => [];
}

class ClearCreateRegionPageCommand extends CreateRegionEvent {
  const ClearCreateRegionPageCommand();

  @override
  String toString() => 'clearCreateRegionPageCommand ';
}

class OnPickImage extends CreateRegionEvent {
  const OnPickImage();

  @override
  String toString() => 'OnImageUpload';
}

class OnNextTapped extends CreateRegionEvent {
  const OnNextTapped();

  @override
  String toString() => 'OnNextTapped';
}

class OnPickImageNextTapped extends CreateRegionEvent {
  const OnPickImageNextTapped();

  @override
  String toString() => 'OnNextTapped';
}


class OnBackPressed extends CreateRegionEvent {
  const OnBackPressed();

  @override
  String toString() => 'OnBackPressed';
}

class OnRegionNameChange extends CreateRegionEvent {
  final String regionName;

  const OnRegionNameChange(this.regionName);

  @override
  String toString() => 'OnRegionNameChange { regionName: $regionName}';
}

class OnRegionDescriptionChange extends CreateRegionEvent {
  final String regionDescription;

  const OnRegionDescriptionChange(this.regionDescription);

  @override
  String toString() => 'OnRegionDescriptionChange { OnRegionDescriptionChange: $regionDescription}';
}

class OnCreateRegionTapped extends CreateRegionEvent {
  const OnCreateRegionTapped();

  @override
  String toString() => 'onCreateRegionTapped';
}
