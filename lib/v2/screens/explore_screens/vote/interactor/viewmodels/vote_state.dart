import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote/interactor/viewmodels/proposal_type_model.dart';

/// --- STATE
class VoteState extends Equatable {
  final PageState pageState;
  final ProposalType currentType;
  final List<ProposalModel>? proposals;
  final String? errorMessage;

  const VoteState({
    required this.pageState,
    required this.currentType,
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
    ProposalType? currentType,
    List<ProposalModel>? proposals,
    String? errorMessage,
  }) {
    return VoteState(
      pageState: pageState ?? this.pageState,
      currentType: currentType ?? this.currentType,
      proposals: proposals,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory VoteState.initial() {
    return VoteState(pageState: PageState.initial, currentType: proposalTypes.first);
  }
}
