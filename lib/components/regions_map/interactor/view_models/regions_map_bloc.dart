import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:seeds/components/regions_map/interactor/usecases/get_places_from_coordinates_use_case.dart';
import 'package:seeds/components/regions_map/interactor/usecases/get_user_location_use_case.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/utils/placemark_extension.dart';

part 'regions_map_event.dart';
part 'regions_map_state.dart';

class RegionsMapBloc extends Bloc<RegionsMapEvent, RegionsMapState> {
  RegionsMapBloc() : super(RegionsMapState.initial()) {
    on<SetInitialValues>(_setInitialValues);
    on<MoveToCurrentLocation>(_moveToCurrentLocation);
    on<OnMapMoving>(_onMapMoving);
    on<OnMapEndMove>(_onMapEndMove);
    on<ToggleSearchBar>((_, emit) => emit(state.copyWith(isSearchingPlace: !state.isSearchingPlace)));
    on<OnPlaceResultSelected>(_onPlaceResultSelected);
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
          pageState: PageState.success,
          newPlace: state.newPlace.copyWith(
            lng: state.initialPlace!.lng,
            lat: state.initialPlace!.lat,
            placeText: placemarks.first.toPlaceText,
          ),
          moveCamera: true,
        ));
      }
    } else {
      final result = await GetUserLocationUseCase().run();
      if (result.isError) {
        emit(state.copyWith(pageState: PageState.failure));
      } else {
        final position = result.asValue!.value;
        final newLatLong = state.newPlace.copyWith(lng: position.longitude, lat: position.latitude);
        emit(state.copyWith(newPlace: newLatLong));
        final place = await placemarkFromCoordinates(state.newPlace.lat, state.newPlace.lng);
        emit(state.copyWith(
          pageState: PageState.success,
          newPlace: state.newPlace.copyWith(placeText: place.first.toPlaceText),
          moveCamera: true,
        ));
      }
    }
  }

  Future<void> _moveToCurrentLocation(MoveToCurrentLocation event, Emitter<RegionsMapState> emit) async {
    emit(state.copyWith(moveCamera: false)); // reset
    final res = await GetUserLocationUseCase().run();
    if (res.isError) {
      emit(state.copyWith(pageState: PageState.failure));
    } else {
      final position = res.asValue!.value;
      final newLatLong = state.newPlace.copyWith(lng: position.longitude, lat: position.latitude);
      emit(state.copyWith(newPlace: newLatLong));
      final result = await GetPlacesFromCoordinatesUseCase().run(GetPlacesFromCoordinatesUseCase.input(
        lat: state.newPlace.lat,
        lng: state.newPlace.lng,
      ));
      if (result.isError) {
        emit(state.copyWith(pageState: PageState.failure));
      } else {
        final placemarks = result.asValue!.value;
        emit(state.copyWith(
          newPlace: state.newPlace.copyWith(placeText: placemarks.first.toPlaceText),
          moveCamera: true,
        ));
      }
    }
  }

  void _onMapMoving(OnMapMoving event, Emitter<RegionsMapState> emit) {
    if (state.markerStatus == MarkerStatus.initial) {
      emit(state.copyWith(markerStatus: MarkerStatus.moving));
    }
    emit(state.copyWith(newPlace: state.newPlace.copyWith(lng: event.pickedLong, lat: event.pickedLat)));
  }

  Future<void> _onMapEndMove(OnMapEndMove event, Emitter<RegionsMapState> emit) async {
    final result = await GetPlacesFromCoordinatesUseCase().run(GetPlacesFromCoordinatesUseCase.input(
      lat: state.newPlace.lat,
      lng: state.newPlace.lng,
    ));
    if (result.isError) {
      emit(state.copyWith(pageState: PageState.failure));
    } else {
      final placemarks = result.asValue!.value;
      emit(state.copyWith(
        newPlace: state.newPlace.copyWith(placeText: placemarks.first.toPlaceText),
        markerStatus: MarkerStatus.initial,
      ));
    }
  }

  void _onPlaceResultSelected(OnPlaceResultSelected event, Emitter<RegionsMapState> emit) {
    emit(state.copyWith(moveCamera: false)); // reset
    // Update place and move map
    emit(state.copyWith(newPlace: event.place, moveCamera: true));
  }
}
