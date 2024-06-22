import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/explore_screens/vote/proposals/proposals_details.i18n.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/proposal_details_bloc.dart';

class VoteStatusLabel extends StatelessWidget {
  const VoteStatusLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalDetailsBloc, ProposalDetailsState>(
      builder: (context, state) {
        if (state.proposals[state.currentIndex].stage == 'active' ||
            state.proposals[state.currentIndex].stage.isEmpty) {
          switch (state.voteStatus) {
            case VoteStatus.notCitizen:
              return Padding(
                padding: const EdgeInsets.only(top: horizontalEdgePadding, left: horizontalEdgePadding),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'You must be a'.i18n, style: Theme.of(context).textTheme.titleSmall),
                          TextSpan(text: ' Citizen '.i18n, style: Theme.of(context).textTheme.subtitle2Green2),
                          TextSpan(text: 'to vote on proposals.'.i18n, style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            case VoteStatus.alreadyVoted:
              return Padding(
                padding: const EdgeInsets.only(top: horizontalEdgePadding, left: horizontalEdgePadding),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'You have already'.i18n, style: Theme.of(context).textTheme.titleSmall),
                          TextSpan(text: ' Voted with '.i18n, style: Theme.of(context).textTheme.subtitle2Green2),
                          TextSpan(
                              text: state.vote!.amount == 1
                                  ? '${state.vote!.amount} ' 'vote '.i18n
                                  : '${state.vote!.amount} ' 'votes'.i18n,
                              style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            case VoteStatus.hasDelegate:
              return Padding(
                padding: const EdgeInsets.only(top: horizontalEdgePadding, left: horizontalEdgePadding),
                child: Row(
                  children: [
                    Flexible(
                      child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'You have delegated your vote to'.i18n,
                                style: Theme.of(context).textTheme.titleSmall),
                            TextSpan(
                                text: ' ${state.proposalDelegate}. ',
                                style: Theme.of(context).textTheme.subtitle2Green2),
                            TextSpan(
                                text: 'They are voting for you.'.i18n, style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            case VoteStatus.canVote:
              return Padding(
                padding: const EdgeInsets.only(top: horizontalEdgePadding, left: horizontalEdgePadding),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Voting'.i18n, style: Theme.of(context).textTheme.titleSmall),
                          TextSpan(
                              text: ' - ${state.proposals[state.currentIndex].proposalCategory.name}: ',
                              style: Theme.of(context).textTheme.subtitle2Green2),
                          TextSpan(
                              text: state.voteAmount == 1
                                  ? '${state.voteAmount} ' 'vote '.i18n
                                  : '${state.voteAmount} ' 'votes'.i18n,
                              style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        } else if (state.proposals[state.currentIndex].stage == 'staged') {
          return Padding(
            padding: const EdgeInsets.only(top: horizontalEdgePadding, left: horizontalEdgePadding),
            child: Row(
              children: [
                Text('Voting for this proposal is not open yet.'.i18n, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
