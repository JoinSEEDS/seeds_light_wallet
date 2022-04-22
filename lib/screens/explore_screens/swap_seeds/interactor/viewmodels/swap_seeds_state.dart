part of 'swap_seeds_bloc.dart';

class SwapSeedsState extends Equatable {
  final NavigateToSendConfirmation? pageCommand;
  final PageState pageState;

  const SwapSeedsState({this.pageCommand, required this.pageState});

  @override
  List<Object?> get props => [pageCommand, pageState];

  SwapSeedsState copyWith({NavigateToSendConfirmation? pageCommand, PageState? pageState}) {
    return SwapSeedsState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
    );
  }

  factory SwapSeedsState.initial() => const SwapSeedsState(pageState: PageState.loading);
}
