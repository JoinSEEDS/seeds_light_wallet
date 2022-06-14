import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/explore_screens/vote/proposals/proposals_details.i18n.dart';
import 'package:seeds/images/vote/arrow_next_proposal.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/components/current_vote_choice_label.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/components/vote_status_label.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/proposal_details_bloc.dart';

class ProposalDetailsBottom extends StatelessWidget {
  const ProposalDetailsBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalDetailsBloc, ProposalDetailsState>(
      builder: (context, state) {
        return Column(
          children: [
            const VoteStatusLabel(),
            if (state.shouldShowNexProposalButton)
              Padding(
                padding: const EdgeInsets.all(horizontalEdgePadding),
                child: InkWell(
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
              ),
            if (state.shouldShowVoteModule)
              Column(
                children: [
                  if (state.tokens!.amount > 0)
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: state.voteAmount.toDouble(),
                            min: -state.tokens!.amount.toDouble(),
                            max: state.tokens!.amount.toDouble(),
                            divisions: 200,
                            label: '${state.voteAmount}',
                            onChanged: (newValue) {
                              BlocProvider.of<ProposalDetailsBloc>(context).add(OnVoteAmountChanged(newValue.round()));
                            },
                          ),
                        )
                      ],
                    ),
                  const CurrentVoteChoiceLabel(),
                  Padding(
                    padding: const EdgeInsets.all(horizontalEdgePadding),
                    child: FlatButtonLong(
                      title: 'Vote'.i18n,
                      onPressed: () {
                        BlocProvider.of<ProposalDetailsBloc>(context).add(const OnVoteButtonPressed());
                      },
                    ),
                  ),
                ],
              )
            else
              const SizedBox(height: 200),
          ],
        );
      },
    );
  }
}
