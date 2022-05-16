part of 'regions_map_bloc.dart';

class RegionsMapState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final Place? initialPlace;
  final List<RegionModel> regions;
  final Place newPlace;
  final bool isCameraMoving;
  final bool isSearchingPlace;
  final bool isUserLocationEnabled;
  final bool showRegionsResults;

  const RegionsMapState({
    this.pageCommand,
    required this.pageState,
    this.initialPlace,
    required this.regions,
    required this.newPlace,
    required this.isCameraMoving,
    required this.isSearchingPlace,
    required this.isUserLocationEnabled,
    required this.showRegionsResults,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        initialPlace,
        regions,
        newPlace,
        isCameraMoving,
        isSearchingPlace,
        isUserLocationEnabled,
      ];

  RegionsMapState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    Place? initialPlace,
    List<RegionModel>? regions,
    Place? newPlace,
    bool? isCameraMoving,
    bool? isSearchingPlace,
    bool? isUserLocationEnabled,
  }) {
    return RegionsMapState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      isCameraMoving: isCameraMoving ?? this.isCameraMoving,
      initialPlace: initialPlace ?? this.initialPlace,
      regions: regions ?? this.regions,
      newPlace: newPlace ?? this.newPlace,
      isSearchingPlace: isSearchingPlace ?? this.isSearchingPlace,
      isUserLocationEnabled: isUserLocationEnabled ?? this.isUserLocationEnabled,
      showRegionsResults: showRegionsResults,
    );
  }

  factory RegionsMapState.initial(bool showRegionsResults, Place? initial) {
    // Copy and modify by a small value to fire the listner
    // (To avoid the cam move so much from the initial position)
    final Place? initialPlace = initial != null
        ? Place(lng: initial.lng - 0.00000000000001, lat: initial.lat - 0.00000000000001, placeText: '')
        : null;
    return RegionsMapState(
      pageState: PageState.initial,
      regions: [],
      initialPlace: initialPlace,
      newPlace: initial ?? const Place(lat: 0, lng: 0, placeText: ''),
      isCameraMoving: false,
      isSearchingPlace: false,
      isUserLocationEnabled: true,
      showRegionsResults: showRegionsResults,
    );
  }
}
