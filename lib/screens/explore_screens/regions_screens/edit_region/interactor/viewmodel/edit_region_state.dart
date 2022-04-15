part of 'edit_region_bloc.dart';

class EditRegionState extends Equatable {
  final String newRegionDescription;
  final RegionModel region;

  const EditRegionState({
    required this.newRegionDescription,
    required this.region,
  });

  @override
  List<Object?> get props => [
        newRegionDescription,
        region,
      ];

  EditRegionState copyWith({
    String? newRegionDescription,
    RegionModel? region,
  }) =>
      EditRegionState(
        newRegionDescription: newRegionDescription ?? this.newRegionDescription,
        region: region ?? this.region,
      );

  factory EditRegionState.initial(RegionModel region) {
    return EditRegionState(
      newRegionDescription: "",
      region: region,
    );
  }
}
