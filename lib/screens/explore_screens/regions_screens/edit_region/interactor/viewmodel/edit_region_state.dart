part of 'edit_region_bloc.dart';

class EditRegionState extends Equatable {
  final String newRegionDescription;
  final RegionModel region;
  final bool isSaveChangesButtonLoading;
  final PageCommand? pageCommand;

  const EditRegionState(
      {required this.newRegionDescription,
      required this.region,
      required this.isSaveChangesButtonLoading,
      this.pageCommand});

  @override
  List<Object?> get props => [
        newRegionDescription,
        region,
        isSaveChangesButtonLoading,
        pageCommand,
      ];

  EditRegionState copyWith({
    String? newRegionDescription,
    RegionModel? region,
    bool? isSaveChangesButtonLoading,
    PageCommand? pageCommand,
  }) =>
      EditRegionState(
        newRegionDescription: newRegionDescription ?? this.newRegionDescription,
        region: region ?? this.region,
        isSaveChangesButtonLoading: isSaveChangesButtonLoading ?? this.isSaveChangesButtonLoading,
        pageCommand: pageCommand,
      );

  factory EditRegionState.initial(RegionModel region) {
    return EditRegionState(
      newRegionDescription: "",
      region: region,
      isSaveChangesButtonLoading: false,
    );
  }
}
