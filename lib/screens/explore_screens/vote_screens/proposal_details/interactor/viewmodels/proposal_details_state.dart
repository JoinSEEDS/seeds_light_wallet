part of '../viewmodels/proposal_details_bloc.dart';

enum VoteStatus { canVote, alreadyVoted, notCitizen, hasDelegate }

class ProposalDetailsState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final int currentIndex;
  final List<ProposalViewModel> proposals;
  final List<CategoryDelegate> currentDelegates;
  final bool showNextButton;
  final bool isCitizen;
  final int voteAmount;
  final ProfileModel? creator;
  final VoteModel? vote;
  final VoiceModel? tokens;

  const ProposalDetailsState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.currentIndex,
    required this.proposals,
    required this.currentDelegates,
    required this.showNextButton,
    required this.isCitizen,
    required this.voteAmount,
    this.creator,
    this.vote,
    this.tokens,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        currentIndex,
        proposals,
        showNextButton,
        isCitizen,
        voteAmount,
        creator,
        vote,
        tokens,
      ];

  VoteStatus get voteStatus {
    if (!isCitizen) {
      return VoteStatus.notCitizen;
    } else if (vote!.isVoted) {
      return VoteStatus.alreadyVoted;
    } else if (proposalDelegate.isNotEmpty) {
      return VoteStatus.hasDelegate;
    } else {
      return VoteStatus.canVote;
    }
  }

  bool get shouldShowNexProposalButton {
    final isVoted = vote?.isVoted ?? false;
    final hasMoreItems = currentIndex < proposals.length - 1;
    final isProposalActive = proposals[currentIndex].stage == 'active' || proposals[currentIndex].status == 'active';
    return (showNextButton || isVoted || !isCitizen || !isProposalActive) && hasMoreItems;
  }

  bool get shouldShowVoteModule {
    final isVoted = vote?.isVoted ?? false;
    final hasDelegate = proposalDelegate.isNotEmpty;
    final isProposalActive = proposals[currentIndex].stage == 'active' || proposals[currentIndex].status == 'active';
    return !showNextButton && !isVoted && isCitizen && isProposalActive && !hasDelegate;
  }

  String get proposalDelegate {
    final target = currentDelegates.singleWhereOrNull((i) => i.category == proposals[currentIndex].proposalCategory);
    return target == null ? '' : target.delegate;
  }

  ProposalDetailsState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    int? currentIndex,
    List<ProposalViewModel>? proposals,
    bool? showNextButton,
    bool? isCitizen,
    int? voteAmount,
    ProfileModel? creator,
    VoteModel? vote,
    VoiceModel? tokens,
  }) {
    return ProposalDetailsState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      currentIndex: currentIndex ?? this.currentIndex,
      proposals: proposals ?? this.proposals,
      currentDelegates: currentDelegates,
      showNextButton: showNextButton ?? this.showNextButton,
      isCitizen: isCitizen ?? this.isCitizen,
      voteAmount: voteAmount ?? this.voteAmount,
      creator: creator ?? this.creator,
      vote: vote ?? this.vote,
      tokens: tokens ?? this.tokens,
    );
  }

  factory ProposalDetailsState.initial(ProposalsArgsData proposalsArgsData) {
    return ProposalDetailsState(
      pageState: PageState.initial,
      currentIndex: proposalsArgsData.index,
      proposals: proposalsArgsData.proposals,
      currentDelegates: proposalsArgsData.currentDelegates,
      showNextButton: false,
      isCitizen: proposalsArgsData.profile.status == ProfileStatus.citizen,
      voteAmount: 0,
    );
  }
}
