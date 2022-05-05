part of 'edit_region_bloc.dart';

abstract class EditRegionEvent extends Equatable {
  const EditRegionEvent();

  @override
  List<Object?> get props => [];
}

class ClearEditRegionPageCommand extends EditRegionEvent {
  const ClearEditRegionPageCommand();

  @override
  String toString() => 'ClearEditRegionPageCommand';
}

class OnPickImage extends EditRegionEvent {
  const OnPickImage();

  @override
  String toString() => 'OnPickImage';
}

class OnSaveImageTapped extends EditRegionEvent {
  const OnSaveImageTapped();

  @override
  String toString() => 'OnSaveImageTapped';
}

class OnRegionDescriptionChange extends EditRegionEvent {
  final String regionDescription;

  const OnRegionDescriptionChange(this.regionDescription);

  @override
  String toString() => 'OnRegionDescriptionChange {regionDescription: $regionDescription}';
}

class OnEditRegionSaveChangesTapped extends EditRegionEvent {
  const OnEditRegionSaveChangesTapped();

  @override
  String toString() => 'OnEditRegionSaveChangesTapped';
}

class OnEditRegionImage extends EditRegionEvent {
  const OnEditRegionImage();

  @override
  String toString() => 'OnEditRegionImage';
}
