import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

/// --- STATE
class ProposalsListState extends Equatable {
  final PageState pageState;
  final ProposalType currentType;
  final List<ProposalModel> proposals;
  final bool hasReachedMax;
  final String? errorMessage;

  const ProposalsListState({
    required this.pageState,
    required this.currentType,
    required this.proposals,
    required this.hasReachedMax,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        currentType,
        proposals,
        hasReachedMax,
        errorMessage,
      ];

  ProposalsListState copyWith({
    PageState? pageState,
    ProposalType? currentType,
    List<ProposalModel>? proposals,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return ProposalsListState(
      pageState: pageState ?? this.pageState,
      currentType: currentType ?? this.currentType,
      proposals: proposals ?? this.proposals,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
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
