import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/images/vote/arrow_next_proposal.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/components/current_vote_choice_label.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/components/vote_status_label.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/i18n/explore_screens/vote/proposals/proposals_details.i18n.dart';

class ProposalDetailsBottom extends StatelessWidget {
  const ProposalDetailsBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalDetailsBloc, ProposalDetailsState>(
      builder: (context, state) {
        return Column(
          children: [
            const VoteStatusLabel(),
            state.showNextButton || state.vote!.isVoted || !state.isCitizen
                ? Padding(
                    padding: const EdgeInsets.all(horizontalEdgePadding),
                    child: Column(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(defaultCardBorderRadius),
                          onTap: () {
                            BlocProvider.of<ProposalDetailsBloc>(context).add(const OnNextProposalTapped());
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              color: AppColors.darkGreen2,
                              borderRadius: BorderRadius.circular(defaultCardBorderRadius),
                            ),
                            child: ListTile(
                              title: Text(
                                'View Next Proposal'.i18n,
                                style: Theme.of(context).textTheme.headline8,
                              ),
                              trailing: const CustomPaint(size: Size(26, 26), painter: ArrowNextProposal()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 200),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      if (state.tokens!.amount > 0)
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: state.voteAmount.toDouble(),
                                min: - state.tokens!.amount.toDouble(),
                                max: state.tokens!.amount.toDouble(),
                                divisions: 200,
                                label: '${state.voteAmount}',
                                onChanged: (newValue) {
                                  BlocProvider.of<ProposalDetailsBloc>(context)
                                      .add(OnVoteAmountChanged(newValue.round()));
                                },
                              ),
                            )
                          ],
                        ),
                      const CurrentVoteChoiceLabel(),
                      Padding(
                        padding: const EdgeInsets.all(horizontalEdgePadding),
                        child: FlatButtonLong(
                          enabled: true,
                          title: 'Vote'.i18n,
                          onPressed: () {
                            BlocProvider.of<ProposalDetailsBloc>(context).add(const OnVoteButtonPressed());
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        );
      },
    );
  }
}
