import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

/// --- STATE
class ProposalsListState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ProposalType currentType;
  final List<ProposalModel> proposals;
  final bool hasReachedMax;

  const ProposalsListState({
    required this.pageState,
    this.errorMessage,
    required this.currentType,
    required this.proposals,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        currentType,
        proposals,
        hasReachedMax,
      ];

  ProposalsListState copyWith({
    PageState? pageState,
    String? errorMessage,
    ProposalType? currentType,
    List<ProposalModel>? proposals,
    bool? hasReachedMax,
  }) {
    return ProposalsListState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
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
