part of 'delegates_bloc.dart';

class DelegatesState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final String? errorMessage;
  final bool activeDelegate;
  final ProfileModel? delegate;
  final bool shouldRefreshCurrentDelegates;

  const DelegatesState({
    this.pageCommand,
    required this.pageState,
    this.errorMessage,
    required this.activeDelegate,
    this.delegate,
    required this.shouldRefreshCurrentDelegates,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        errorMessage,
        activeDelegate,
        delegate,
        shouldRefreshCurrentDelegates,
      ];

  DelegatesState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    String? errorMessage,
    bool? activeDelegate,
    ProfileModel? delegate,
    bool? shouldRefreshCurrentDelegates,
  }) {
    return DelegatesState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      activeDelegate: activeDelegate ?? this.activeDelegate,
      delegate: delegate ?? this.delegate,
      shouldRefreshCurrentDelegates: shouldRefreshCurrentDelegates ?? this.shouldRefreshCurrentDelegates,
    );
  }

  factory DelegatesState.initial() {
    return const DelegatesState(
      pageState: PageState.initial,
      activeDelegate: false,
      shouldRefreshCurrentDelegates: false,
    );
  }
}
