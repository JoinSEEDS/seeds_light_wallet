import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/datasource/remote/model/proposals_model.dart';
import 'package:seeds/v2/datasource/remote/model/voice_model.dart';
import 'package:seeds/v2/datasource/remote/model/vote_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_args_data.dart';

enum PrecastStatus { canPrecast, alreadyPrecasted, allTokensUsed, notCitizen }

/// --- STATE
class ProposalDetailsState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final int currentIndex;
  final List<ProposalModel> proposals;
  final bool showNextButton;
  final bool isCitizen;
  final int voteAmount;
  final ProfileModel? creator;
  final VoteModel? vote;
  final VoiceModel? tokens;

  PrecastStatus get precastStatus {
    if (!isCitizen) {
      return PrecastStatus.notCitizen;
    } else if (vote!.amount != 0) {
      return PrecastStatus.alreadyPrecasted;
    } else if (tokens!.amount <= 0) {
      return PrecastStatus.allTokensUsed;
    } else {
      return PrecastStatus.canPrecast;
    }
  }

  const ProposalDetailsState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.currentIndex,
    required this.proposals,
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

  ProposalDetailsState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    int? currentIndex,
    List<ProposalModel>? proposals,
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
      showNextButton: false,
      isCitizen: proposalsArgsData.profile.status == ProfileStatus.citizen,
      voteAmount: 0,
    );
  }
}
