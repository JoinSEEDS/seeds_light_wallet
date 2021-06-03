import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// --- STATE
class VoteState extends Equatable {
  final PageState pageState;
  final Map<String, Map> proposalTypes;
  final Map<String, String>? currentType;
  final List<ProposalModel>? proposals;
  final String? errorMessage;

  const VoteState({
    required this.pageState,
    required this.proposalTypes,
    this.currentType,
    this.proposals,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        currentType,
        proposals,
        errorMessage,
      ];

  VoteState copyWith({
    PageState? pageState,
    List<ProposalModel>? proposals,
    Map<String, String>? currentType,
    String? errorMessage,
  }) {
    return VoteState(
      pageState: pageState ?? this.pageState,
      proposalTypes: proposalTypes,
      currentType: currentType ?? this.currentType,
      proposals: proposals,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory VoteState.initial() {
    return const VoteState(
      pageState: PageState.initial,
      proposalTypes: {
        'Open': {'stage': 'active', 'status': 'open'},
        'Evaluate': {'stage': 'active', 'status': 'evaluate', 'reverse': 'true'},
        'Passed': {'stage': 'done', 'status': 'passed', 'reverse': 'true'},
        'Failed': {'stage': 'done', 'status': 'rejected', 'reverse': 'true'},
      },
    );
  }
}
