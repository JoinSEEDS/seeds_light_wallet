import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/components/regions_map/interactor/usecases/get_place_details_use_case.dart';
import 'package:seeds/components/regions_map/interactor/usecases/get_places_autocomplete_use_case.dart';
import 'package:seeds/components/regions_map/interactor/usecases/get_user_location_use_case.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/remote/model/google_places_models/place_details_model.dart';
import 'package:seeds/datasource/remote/model/google_places_models/prediction_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'search_places_event.dart';
part 'search_places_state.dart';

class SearchPlacesBloc extends Bloc<SearchPlacesEvent, SearchPlacesState> {
  SearchPlacesBloc() : super(SearchPlacesState.initial()) {
    on<OnQueryTextChange>(_onQueryTextChange, transformer: _transformEvents);
    on<OnPredictionSelected>(_onPredictionSelected);
  }

  /// Debounce to avoid making search network calls each time the user types
  /// switchMap: To remove the previous event. Every time a new Stream is created, the previous Stream is discarded.
  Stream<OnQueryTextChange> _transformEvents(
      Stream<OnQueryTextChange> events, Stream<OnQueryTextChange> Function(OnQueryTextChange) transitionFn) {
    return events.debounceTime(const Duration(milliseconds: 300)).switchMap(transitionFn);
  }

  Future<void> _onQueryTextChange(OnQueryTextChange event, Emitter<SearchPlacesState> emit) async {
    if (event.query.isNotEmpty) {
      emit(state.copyWith(pageState: PageState.success, showLinearIndicator: true));
      final result = await GetUserLocationUseCase().run();
      if (result.isError) {
        emit(state.copyWith(pageState: PageState.failure));
      } else {
        final Position position = result.asValue!.value;
        final res = await GetPlacesAutocompleteUseCase().run(GetPlacesAutocompleteUseCase.input(
          event.query,
          location: Location(lat: position.latitude, lng: position.longitude),
          language: 'en',
        ));

        if (res.isError) {
          emit(state.copyWith(pageState: PageState.failure, showLinearIndicator: false));
        } else {
          final PlacesAutocompleteResponse response = res.asValue!.value;
          emit(state.copyWith(
            pageState: PageState.success,
            showLinearIndicator: false,
            predictions: response.predictions,
          ));
        }
      }
    } else {
      emit(state.copyWith(predictions: []));
    }
  }

  Future<void> _onPredictionSelected(OnPredictionSelected event, Emitter<SearchPlacesState> emit) async {
    final result = await GetPlaceDetailsUseCase().run(GetPlaceDetailsUseCase.input(event.prediction.placeId));
    if (result.isError) {
      emit(state.copyWith(pageState: PageState.failure));
    } else {
      final PlacesDetailsResponse details = result.asValue!.value;
      emit(state.copyWith(
          placeSelected: Place(
        placeText: event.prediction.description,
        lng: details.result.geometry.location.lng,
        lat: details.result.geometry.location.lat,
      )));
    }
  }
}
