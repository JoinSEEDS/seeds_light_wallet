part of 'edit_region_bloc.dart';

class EditRegionState extends Equatable {
  final String regionDescription;

  const EditRegionState({
    required this.regionDescription,
  });

  @override
  List<Object?> get props => [
        regionDescription,
      ];

  EditRegionState copyWith({
    String? regionDescription,
  }) =>
      EditRegionState(
        regionDescription: regionDescription ?? this.regionDescription,
      );

  factory EditRegionState.initial() {
    return const EditRegionState(
      regionDescription: "",
    );
  }
}
