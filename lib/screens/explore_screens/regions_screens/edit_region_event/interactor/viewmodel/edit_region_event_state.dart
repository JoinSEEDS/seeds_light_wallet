part of 'edit_region_event_bloc.dart';

class EditRegionEventState extends Equatable {
  final String newRegionEventDescription;
  final String newRegionEventName;
  final RegionEventModel event;
  final bool isSaveChangesButtonLoading;
  final PageCommand? pageCommand;

  const EditRegionEventState(
      {required this.newRegionEventDescription,
      required this.newRegionEventName,
      required this.event,
      required this.isSaveChangesButtonLoading,
      this.pageCommand});

  @override
  List<Object?> get props => [
        newRegionEventDescription,
        newRegionEventName,
        event,
        isSaveChangesButtonLoading,
        pageCommand,
      ];

  EditRegionEventState copyWith({
    String? newRegionEventDescription,
    String? newRegionEventName,
    RegionEventModel? event,
    bool? isSaveChangesButtonLoading,
    PageCommand? pageCommand,
  }) =>
      EditRegionEventState(
        newRegionEventDescription: newRegionEventDescription ?? this.newRegionEventDescription,
        newRegionEventName: newRegionEventName ?? this.newRegionEventName,
        event: event ?? this.event,
        isSaveChangesButtonLoading: isSaveChangesButtonLoading ?? this.isSaveChangesButtonLoading,
        pageCommand: pageCommand,
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
