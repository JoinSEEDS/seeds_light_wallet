part of 'p2p_bloc.dart';

class P2PState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;

  const P2PState({this.pageCommand, required this.pageState});

  @override
  List<Object?> get props => [pageCommand, pageState];

  P2PState copyWith({PageCommand? pageCommand, PageState? pageState}) {
    return P2PState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
    );
  }

  factory P2PState.initial() => const P2PState(pageState: PageState.loading);
}
