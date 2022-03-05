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

class OnNextTapped extends CreateRegionEvent {
  const OnNextTapped();

  @override
  String toString() => 'OnNextTapped}';
}

class OnBackPressed extends CreateRegionEvent {
  const OnBackPressed();

  @override
  String toString() => 'OnBackPressed';
}

class OnCreateRegionTapped extends CreateRegionEvent {
  const OnCreateRegionTapped();

  @override
  String toString() => 'onCreateRegionTapped';
}
