part of 'search_places_bloc.dart';

abstract class SearchPlacesEvent extends Equatable {
  const SearchPlacesEvent();

  @override
  List<Object?> get props => [];
}

class OnQueryTextChange extends SearchPlacesEvent {
  final String query;

  const OnQueryTextChange(this.query);

  @override
  List<Object?> get props => [query];

  @override
  String toString() => 'OnQueryTextChange { query: $query }';
}

class OnPredictionSelected extends SearchPlacesEvent {
  final PredictionModel prediction;

  const OnPredictionSelected(this.prediction);

  @override
  List<Object?> get props => [prediction];

  @override
  String toString() => 'OnPredictionSelected { prediction: $prediction }';
}
