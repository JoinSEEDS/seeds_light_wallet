part of 'regions_search_results_bloc.dart';

abstract class RegionsSearchResultsEvent extends Equatable {
  const RegionsSearchResultsEvent();

  @override
  List<Object> get props => [];
}

class OnUpdateMapLocation extends RegionsSearchResultsEvent {
  final Place place;

  const OnUpdateMapLocation(this.place);

  @override
  String toString() => 'OnUpdateMapLocation';
}

class ClearRegionsSearchResultsPageCommand extends RegionsSearchResultsEvent {
  const ClearRegionsSearchResultsPageCommand();

  @override
  String toString() => 'ClearRegionsSearchResultsPageCommand';
}
