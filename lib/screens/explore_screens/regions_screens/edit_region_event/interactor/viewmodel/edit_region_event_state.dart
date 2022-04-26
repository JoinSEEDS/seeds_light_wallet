part of 'edit_region_event_bloc.dart';

class EditRegionEventState extends Equatable {
  final String newRegionEventDescription;
  final String newRegionEventName;
  final RegionEventModel event;
  final bool isSaveChangesButtonLoading;
  final PageCommand? pageCommand;
  final Place? newPlace;

  const EditRegionEventState({
    required this.newRegionEventDescription,
    required this.newRegionEventName,
    required this.event,
    required this.isSaveChangesButtonLoading,
    this.pageCommand,
    this.newPlace,
  });

  @override
  List<Object?> get props => [
        newRegionEventDescription,
        newRegionEventName,
        event,
        isSaveChangesButtonLoading,
        pageCommand,
        newPlace,
      ];

  EditRegionEventState copyWith({
    String? newRegionEventDescription,
    String? newRegionEventName,
    RegionEventModel? event,
    bool? isSaveChangesButtonLoading,
    PageCommand? pageCommand,
    Place? newPlace,
  }) =>
      EditRegionEventState(
        newRegionEventDescription: newRegionEventDescription ?? this.newRegionEventDescription,
        newRegionEventName: newRegionEventName ?? this.newRegionEventName,
        event: event ?? this.event,
        isSaveChangesButtonLoading: isSaveChangesButtonLoading ?? this.isSaveChangesButtonLoading,
        pageCommand: pageCommand,
        newPlace: newPlace ?? this.newPlace,
      );

  factory EditRegionEventState.initial(RegionEventModel event) {
    return EditRegionEventState(
      newRegionEventDescription: "",
      newRegionEventName: "",
      event: event,
      isSaveChangesButtonLoading: false,
    );
  }
}
