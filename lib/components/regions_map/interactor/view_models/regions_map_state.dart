part of 'regions_map_bloc.dart';

class RegionsMapState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final Place? initialPlace;
  final Place newPlace;
  final bool isCameraMoving;
  final bool isSearchingPlace;

  const RegionsMapState({
    this.pageCommand,
    required this.pageState,
    this.initialPlace,
    required this.newPlace,
    required this.isCameraMoving,
    required this.isSearchingPlace,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        initialPlace,
        newPlace,
        isCameraMoving,
        isSearchingPlace,
      ];

  RegionsMapState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    Place? initialPlace,
    Place? newPlace,
    bool? isCameraMoving,
    bool? isSearchingPlace,
  }) {
    return RegionsMapState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      isCameraMoving: isCameraMoving ?? this.isCameraMoving,
      initialPlace: initialPlace ?? this.initialPlace,
      newPlace: newPlace ?? this.newPlace,
      isSearchingPlace: isSearchingPlace ?? this.isSearchingPlace,
    );
  }

  factory RegionsMapState.initial() {
    // When we use this map to edit a Region we can get and set intial values
    // from that region
    // final initial = const Place(lat: 0, lng: 0, placeText: '');
    return const RegionsMapState(
      pageState: PageState.initial,
      // initialPlace: initial,
      // copy and modify by a small value to fire the listner
      // (To avoid the cam move so much from the initial position)
      // newPlace: Place(lng: initial.lng - 0.00000000000001, lat: initial.lat - 0.00000000000001, placeText: ''),
      newPlace: Place(lat: 0, lng: 0, placeText: ''),
      isCameraMoving: false,
      isSearchingPlace: false,
    );
  }
}
