import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_and_index.dart';

/// --- STATE
class ProposalDetailsState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final int currentIndex;
  final List<ProposalModel> proposals;
  final bool showNextButton;
  final bool isConfirmButtonEnabled;
  final ProfileModel? creator;

  const ProposalDetailsState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.currentIndex,
    required this.proposals,
    required this.showNextButton,
    required this.isConfirmButtonEnabled,
    this.creator,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        currentIndex,
        proposals,
        showNextButton,
        isConfirmButtonEnabled,
        creator,
      ];

  ProposalDetailsState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    int? currentIndex,
    List<ProposalModel>? proposals,
    bool? showNextButton,
    bool? isConfirmButtonEnabled,
    ProfileModel? creator,
  }) {
    return ProposalDetailsState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      currentIndex: currentIndex ?? this.currentIndex,
      proposals: proposals ?? this.proposals,
      showNextButton: showNextButton ?? this.showNextButton,
      isConfirmButtonEnabled: isConfirmButtonEnabled ?? this.isConfirmButtonEnabled,
      creator: creator,
    );
  }

  factory ProposalDetailsState.initial(ProposalsAndIndex proposalsAndIndex) {
    return ProposalDetailsState(
      pageState: PageState.initial,
      currentIndex: proposalsAndIndex.index,
      proposals: proposalsAndIndex.proposals,
      showNextButton: false,
      isConfirmButtonEnabled: false,
    );
  }
}
