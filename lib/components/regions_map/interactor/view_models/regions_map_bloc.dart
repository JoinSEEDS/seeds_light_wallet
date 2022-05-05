import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:seeds/components/regions_map/interactor/usecases/get_places_from_coordinates_use_case.dart';
import 'package:seeds/components/regions_map/interactor/usecases/get_user_location_use_case.dart';
import 'package:seeds/components/regions_map/interactor/view_models/page_commands.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/utils/placemark_extension.dart';

part 'regions_map_event.dart';
part 'regions_map_state.dart';

/// This is de default coordinates when user deny location permissions
///
/// first element is longitude and second latitude
/// This coordinates belongs to an area nerby Mexico city.
const defaultLocation = [-99.085092, 19.461416];

class RegionsMapBloc extends Bloc<RegionsMapEvent, RegionsMapState> {
  RegionsMapBloc(List<RegionModel>? regions, Place? initial) : super(RegionsMapState.initial(regions, initial)) {
    on<SetInitialValues>(_setInitialValues);
    on<MoveToCurrentLocation>(_moveToCurrentLocation);
    on<OnMapMoving>((_, emit) => emit(state.copyWith(isCameraMoving: true)));
    on<OnMapEndMove>(_onMapEndMove);
    on<ToggleSearchBar>((_, emit) => emit(state.copyWith(isSearchingPlace: !state.isSearchingPlace)));
    on<OnPlaceResultSelected>(_onPlaceResultSelected);
    on<ClearRegionsMapPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _setInitialValues(SetInitialValues event, Emitter<RegionsMapState> emit) async {
    if (state.initialPlace != null) {
      final result = await GetPlacesFromCoordinatesUseCase().run(GetPlacesFromCoordinatesUseCase.input(
        lat: state.initialPlace!.lat,
        lng: state.initialPlace!.lng,
      ));
      if (result.isError) {
        emit(state.copyWith(pageState: PageState.failure));
      } else {
        final placemarks = result.asValue!.value;
        emit(state.copyWith(
          pageCommand: MoveCamera(),
          pageState: PageState.success,
          newPlace: state.newPlace.copyWith(
            lng: state.initialPlace!.lng,
            lat: state.initialPlace!.lat,
            placeText: placemarks.first.toPlaceText,
          ),
        ));
      }
    } else {
      final result = await GetUserLocationUseCase().run();
      if (result.isError) {
        // User deny location permissions set default location: Mexico city coords
        // and hide current location button.
        emit(state.copyWith(newPlace: state.newPlace.copyWith(lng: defaultLocation.first, lat: defaultLocation.last)));
        final place = await placemarkFromCoordinates(state.newPlace.lat, state.newPlace.lng);
        emit(state.copyWith(
          pageCommand: MoveCamera(),
          pageState: PageState.success,
          newPlace: state.newPlace.copyWith(placeText: place.first.toPlaceText),
          isUserLocationEnabled: false,
        ));
      } else {
        final position = result.asValue!.value;
        emit(state.copyWith(newPlace: state.newPlace.copyWith(lng: position.longitude, lat: position.latitude)));
        final place = await placemarkFromCoordinates(state.newPlace.lat, state.newPlace.lng);
        emit(state.copyWith(
          pageCommand: MoveCamera(),
          pageState: PageState.success,
          newPlace: state.newPlace.copyWith(placeText: place.first.toPlaceText),
          isUserLocationEnabled: true,
        ));
      }
    }
  }

  Future<void> _moveToCurrentLocation(MoveToCurrentLocation event, Emitter<RegionsMapState> emit) async {
    final res = await GetUserLocationUseCase().run();
    if (res.isError) {
      emit(state.copyWith(pageState: PageState.failure));
    } else {
      final position = res.asValue!.value;
      emit(state.copyWith(newPlace: state.newPlace.copyWith(lng: position.longitude, lat: position.latitude)));
      final result = await GetPlacesFromCoordinatesUseCase()
          .run(GetPlacesFromCoordinatesUseCase.input(lat: state.newPlace.lat, lng: state.newPlace.lng));
      if (result.isError) {
        emit(state.copyWith(pageState: PageState.failure));
      } else {
        final placemarks = result.asValue!.value;
        emit(state.copyWith(
          pageCommand: MoveCamera(),
          newPlace: state.newPlace.copyWith(placeText: placemarks.first.toPlaceText),
        ));
      }
    }
  }

  Future<void> _onMapEndMove(OnMapEndMove event, Emitter<RegionsMapState> emit) async {
    if (event.pickedLat != 0 && event.pickedLong != 0) {
      final result = await GetPlacesFromCoordinatesUseCase()
          .run(GetPlacesFromCoordinatesUseCase.input(lat: event.pickedLat, lng: event.pickedLong));
      if (result.isError) {
        // No address information found for supplied coordinates.
      } else {
        final placemarks = result.asValue!.value;
        emit(state.copyWith(
          pageCommand: MoveCameraStop(),
          newPlace: state.newPlace.copyWith(
            lat: event.pickedLat,
            lng: event.pickedLong,
            placeText: placemarks.first.toPlaceText,
          ),
          isCameraMoving: false,
        ));
      }
    }
  }

  void _onPlaceResultSelected(OnPlaceResultSelected event, Emitter<RegionsMapState> emit) {
    emit(state.copyWith(pageCommand: MoveCamera(), isSearchingPlace: false, newPlace: event.place));
  }
}
