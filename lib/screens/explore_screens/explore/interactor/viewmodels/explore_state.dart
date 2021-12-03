part of 'explore_bloc.dart';

class ExploreState extends Equatable {
  final PageCommand? pageCommand;

  const ExploreState({this.pageCommand});

  @override
  List<Object?> get props => [pageCommand];

  ExploreState copyWith({PageCommand? pageCommand}) {
    return ExploreState(pageCommand: pageCommand);
  }

  factory ExploreState.initial() => const ExploreState();
}
