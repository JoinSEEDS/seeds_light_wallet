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

class OnSelectDateChanged extends EditRegionEventEvents {
  final DateTime? selectedDate;

  const OnSelectDateChanged(this.selectedDate);

  @override
  String toString() => 'onSelectDateChanged{newDateTime: $selectedDate}';
}

class OnStartTimeChanged extends EditRegionEventEvents {
  final TimeOfDay? selectedTime;

  const OnStartTimeChanged(this.selectedTime);

  @override
  String toString() => 'onSelectDateChanged{selectedTime: $selectedTime}';
}

class OnEndTimeChanged extends EditRegionEventEvents {
  final TimeOfDay? selectedTime;

  const OnEndTimeChanged(this.selectedTime);

  @override
  String toString() => 'OnEndTimeChanged{selectedTime: $selectedTime}';
}
