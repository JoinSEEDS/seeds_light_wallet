part of 'edit_region_event_bloc.dart';

class EditRegionEventState extends Equatable {
  final String newRegionEventDescription;
  final String newRegionEventName;
  final RegionEventModel event;
  final bool isSaveChangesButtonLoading;
  final bool isSaveChangesButtonEnable;
  final bool isNewNameNotEmpty;
  final bool isNewDescriptionNotEmpty;
  final PageCommand? pageCommand;

  const EditRegionEventState(
      {required this.newRegionEventDescription,
      required this.newRegionEventName,
      required this.event,
      required this.isSaveChangesButtonLoading,
      required this.isSaveChangesButtonEnable,
      required this.isNewNameNotEmpty,
      required this.isNewDescriptionNotEmpty,
      this.pageCommand});

  @override
  List<Object?> get props => [
        newRegionEventDescription,
        newRegionEventName,
        event,
        isSaveChangesButtonLoading,
        isSaveChangesButtonEnable,
        isNewNameNotEmpty,
        isNewDescriptionNotEmpty,
        pageCommand,
      ];

  EditRegionEventState copyWith({
    String? newRegionEventDescription,
    String? newRegionEventName,
    RegionEventModel? event,
    bool? isSaveChangesButtonLoading,
    bool? isSaveChangesButtonEnable,
    bool? isNewNameNotEmpty,
    bool? isNewDescriptionNotEmpty,
    PageCommand? pageCommand,
  }) =>
      EditRegionEventState(
        newRegionEventDescription: newRegionEventDescription ?? this.newRegionEventDescription,
        newRegionEventName: newRegionEventName ?? this.newRegionEventName,
        event: event ?? this.event,
        isSaveChangesButtonLoading: isSaveChangesButtonLoading ?? this.isSaveChangesButtonLoading,
        isSaveChangesButtonEnable: isSaveChangesButtonEnable ?? this.isSaveChangesButtonEnable,
        isNewNameNotEmpty: isNewNameNotEmpty ?? this.isNewNameNotEmpty,
        isNewDescriptionNotEmpty: isNewDescriptionNotEmpty ?? this.isNewDescriptionNotEmpty,
        pageCommand: pageCommand,
      );

  factory EditRegionEventState.initial(RegionEventModel event) {
    return EditRegionEventState(
      newRegionEventDescription: "",
      newRegionEventName: "",
      event: event,
      isSaveChangesButtonLoading: false,
      isSaveChangesButtonEnable: false,
      isNewDescriptionNotEmpty: true,
      isNewNameNotEmpty: true,
    );
  }
}
