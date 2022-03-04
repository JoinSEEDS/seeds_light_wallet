part of 'search_places_bloc.dart';

class SearchPlacesState extends Equatable {
  final PageState pageState;
  final List<Prediction> predictions;
  final bool showLinearIndicator;
  final Place? placeSelected;

  const SearchPlacesState({
    required this.pageState,
    required this.predictions,
    required this.showLinearIndicator,
    this.placeSelected,
  });

  @override
  List<Object?> get props => [
        pageState,
        predictions,
        showLinearIndicator,
        placeSelected,
      ];

  SearchPlacesState copyWith({
    PageState? pageState,
    List<Prediction>? predictions,
    bool? showLinearIndicator,
    Place? placeSelected,
  }) {
    return SearchPlacesState(
      pageState: pageState ?? this.pageState,
      predictions: predictions ?? this.predictions,
      showLinearIndicator: showLinearIndicator ?? this.showLinearIndicator,
      placeSelected: placeSelected ?? this.placeSelected,
    );
  }

  factory SearchPlacesState.initial() {
    return const SearchPlacesState(pageState: PageState.initial, predictions: [], showLinearIndicator: false);
  }
}
