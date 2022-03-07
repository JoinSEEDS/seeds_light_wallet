part of 'regions_map_bloc.dart';

enum MarkerStatus { initial, moving }

class RegionsMapState extends Equatable {
  final PageState pageState;
  final MarkerStatus markerStatus;
  final Place? initialPlace;
  final Place newPlace;
  final bool moveCamera;
  final bool addressUpdated;
  final bool isSearchingPlace;

  const RegionsMapState({
    required this.pageState,
    required this.markerStatus,
    this.initialPlace,
    required this.newPlace,
    required this.moveCamera,
    required this.addressUpdated,
    required this.isSearchingPlace,
  });

  @override
  List<Object?> get props => [
        pageState,
        markerStatus,
        initialPlace,
        newPlace,
        moveCamera,
        addressUpdated,
        isSearchingPlace,
      ];

  RegionsMapState copyWith({
    PageState? pageState,
    MarkerStatus? markerStatus,
    Place? initialPlace,
    Place? newPlace,
    bool? moveCamera,
    bool? addressUpdated,
    bool? isSearchingPlace,
  }) {
    return RegionsMapState(
      pageState: pageState ?? this.pageState,
      markerStatus: markerStatus ?? this.markerStatus,
      initialPlace: initialPlace ?? this.initialPlace,
      newPlace: newPlace ?? this.newPlace,
      moveCamera: moveCamera ?? this.moveCamera,
      addressUpdated: addressUpdated ?? this.addressUpdated,
      isSearchingPlace: isSearchingPlace ?? this.isSearchingPlace,
    );
  }

  factory RegionsMapState.initial() {
    // When we use this map to edit a Region we can get and set intial values
    // from that region
    // final initial = const Place(lat: 0, lng: 0, placeText: '');
    return const RegionsMapState(
      pageState: PageState.initial,
      markerStatus: MarkerStatus.initial,
      // initialPlace: initial,
      // copy and modify by a small value to fire the listner
      // (To avoid the cam move so much from the initial position)
      // newPlace: Place(lng: initial.lng - 0.00000000000001, lat: initial.lat - 0.00000000000001, placeText: ''),
      newPlace: Place(lat: 0, lng: 0, placeText: ''),
      moveCamera: false,
      addressUpdated: false,
      isSearchingPlace: false,
    );
  }
}
