import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/components/regions_map/components/serach_places/interactor/mappers/predictions_state_mapper.dart';
import 'package:seeds/components/regions_map/components/serach_places/interactor/usecases/get_place_details_use_case.dart';
import 'package:seeds/components/regions_map/components/serach_places/interactor/usecases/get_places_autocomplete_use_case.dart';
import 'package:seeds/components/regions_map/interactor/usecases/get_user_location_use_case.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/datasource/remote/model/google_places_models/place_details_model.dart';
import 'package:seeds/datasource/remote/model/google_places_models/prediction_model.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'search_places_event.dart';

part 'search_places_state.dart';

class SearchPlacesBloc extends Bloc<SearchPlacesEvent, SearchPlacesState> {
  SearchPlacesBloc(List<RegionModel> regions) : super(SearchPlacesState.initial(regions)) {
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

      final List<PredictionModel> regionMatches = [];
      // If regions not empty search them by matches and aggregates
      if (state.regions.isNotEmpty) {
        for (final i in state.regions) {
          if (i.title.contains(event.query)) {
            regionMatches.add(PredictionModel(placeId: i.id, description: i.title));
          } else if (i.id.contains(event.query)) {
            regionMatches.add(PredictionModel(placeId: i.id, description: i.id));
          }
        }
      }

      final locationStatus = await Permission.location.status;
      final locationIsEnabled = await Permission.locationWhenInUse.serviceStatus.isEnabled;
      if (locationStatus.isDenied ||
          locationStatus.isPermanentlyDenied ||
          locationStatus.isRestricted ||
          !locationIsEnabled) {
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
        final res = await GetPlacesAutocompleteUseCase().run(GetPlacesAutocompleteUseCase.input(
          event.query,
          language: 'en',
        ));
        emit(PredictionsStateMapper().mapResultToState(state, res, regionMatches));
      } else {
        // We have user location permission use location to improve near results.
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

          emit(PredictionsStateMapper().mapResultToState(state, res, regionMatches));
        }
      }
    } else {
      emit(state.copyWith(predictions: []));
    }
  }

  Future<void> _onPredictionSelected(OnPredictionSelected event, Emitter<SearchPlacesState> emit) async {
    bool isRegionSelected = false;
    if (state.regions.isNotEmpty) {
      final selected = state.regions.singleWhereOrNull((i) => i.id == event.prediction.placeId);
      if (selected != null) {
        emit(state.copyWith(
            placeSelected: Place(
          placeText: selected.title,
          lng: selected.longitude,
          lat: selected.latitude,
        )));
        isRegionSelected = true;
      }
    }
    if (!isRegionSelected) {
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
}
