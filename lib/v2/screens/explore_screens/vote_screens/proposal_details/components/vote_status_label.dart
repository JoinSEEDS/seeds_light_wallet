import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/i18n/explore_screens/vote/proposals/proposals_details.i18n.dart';
import '../interactor/viewmodels/proposal_details_bloc.dart';

class VoteStatusLabel extends StatelessWidget {
  const VoteStatusLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalDetailsBloc, ProposalDetailsState>(
      builder: (context, state) {
        switch (state.voteStatus) {
          case VoteStatus.notCitizen:
            return Padding(
              padding: const EdgeInsets.only(top: horizontalEdgePadding, left: horizontalEdgePadding),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'You must be a'.i18n, style: Theme.of(context).textTheme.subtitle2),
                        TextSpan(text: ' Citizen '.i18n, style: Theme.of(context).textTheme.subtitle2Green2),
                        TextSpan(text: 'to vote on proposals.'.i18n, style: Theme.of(context).textTheme.subtitle2),
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
                        TextSpan(text: 'You have already'.i18n, style: Theme.of(context).textTheme.subtitle2),
                        TextSpan(text: ' Voted with '.i18n, style: Theme.of(context).textTheme.subtitle2Green2),
                        TextSpan(
                            text: state.voteAmount == 1
                                ? '${state.voteAmount} ' + 'vote '.i18n
                                : '${state.voteAmount} ' + 'votes'.i18n,
                            style: Theme.of(context).textTheme.subtitle2),
                      ],
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
                        TextSpan(text: 'Voting'.i18n, style: Theme.of(context).textTheme.subtitle2),
                        TextSpan(
                            text: ' - ${state.proposals[state.currentIndex].campaignTypeLabel}: ',
                            style: Theme.of(context).textTheme.subtitle2Green2),
                        TextSpan(
                            text: state.voteAmount == 1
                                ? '${state.voteAmount} ' + 'vote '.i18n
                                : '${state.voteAmount} ' + 'votes'.i18n,
                            style: Theme.of(context).textTheme.subtitle2),
                      ],
                    ),
                  ),
                ],
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
