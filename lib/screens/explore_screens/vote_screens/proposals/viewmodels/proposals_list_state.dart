part of '../viewmodels/proposals_list_bloc.dart';

class ProposalsListState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final ProfileModel? profile;
  final ProposalType currentType;
  final List<ProposalViewModel> proposals;
  final bool hasReachedMax;

  const ProposalsListState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    this.profile,
    required this.currentType,
    required this.proposals,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        profile,
        currentType,
        proposals,
        hasReachedMax,
      ];

  ProposalsListState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    ProfileModel? profile,
    ProposalType? currentType,
    List<ProposalViewModel>? proposals,
    bool? hasReachedMax,
  }) {
    return ProposalsListState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      profile: profile ?? this.profile,
      currentType: currentType ?? this.currentType,
      proposals: proposals ?? this.proposals,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  factory ProposalsListState.initial(ProposalType proposalType) {
    return ProposalsListState(
      pageState: PageState.initial,
      currentType: proposalType,
      proposals: const [],
      hasReachedMax: false,
    );
  }
}
