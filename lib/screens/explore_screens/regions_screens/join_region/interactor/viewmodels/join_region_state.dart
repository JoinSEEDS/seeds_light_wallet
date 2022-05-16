part of 'join_region_bloc.dart';

class JoinRegionState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final bool isCreateRegionButtonLoading;
  final bool isRegionsResultsEmpty;

  const JoinRegionState({
    this.pageCommand,
    required this.pageState,
    required this.isCreateRegionButtonLoading,
    required this.isRegionsResultsEmpty,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        isCreateRegionButtonLoading,
        isRegionsResultsEmpty,
      ];

  JoinRegionState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    bool? isCreateRegionButtonLoading,
    bool? isRegionsResultsEmpty,
  }) {
    return JoinRegionState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      isCreateRegionButtonLoading: isCreateRegionButtonLoading ?? this.isCreateRegionButtonLoading,
      isRegionsResultsEmpty: isRegionsResultsEmpty ?? this.isRegionsResultsEmpty,
    );
  }

  factory JoinRegionState.initial() {
    return const JoinRegionState(
      pageState: PageState.initial,
      isCreateRegionButtonLoading: false,
      isRegionsResultsEmpty: true,
    );
  }
}
