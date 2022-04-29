part of 'search_places_bloc.dart';

class SearchPlacesState extends Equatable {
  final PageState pageState;
  final List<PredictionModel> predictions;
  final bool showLinearIndicator;
  final Place? placeSelected;
  final List<RegionModel> regions;

  const SearchPlacesState({
    required this.pageState,
    required this.predictions,
    required this.showLinearIndicator,
    this.placeSelected,
    required this.regions,
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
    List<PredictionModel>? predictions,
    bool? showLinearIndicator,
    Place? placeSelected,
  }) {
    return SearchPlacesState(
      pageState: pageState ?? this.pageState,
      predictions: predictions ?? this.predictions,
      showLinearIndicator: showLinearIndicator ?? this.showLinearIndicator,
      placeSelected: placeSelected ?? this.placeSelected,
      regions: regions,
    );
  }

  factory SearchPlacesState.initial(List<RegionModel> regions) {
    return SearchPlacesState(
      pageState: PageState.initial,
      predictions: [],
      showLinearIndicator: false,
      regions: regions,
    );
  }
}
