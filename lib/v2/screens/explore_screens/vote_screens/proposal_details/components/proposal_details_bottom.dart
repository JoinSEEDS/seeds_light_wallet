import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/images/vote/arrow_next_proposal.dart';
import 'package:seeds/v2/images/vote/votes_abstain_slash.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/viewmodels/bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/i18n/explore_screens/vote/proposals/proposals_details.i18n.dart';
import 'package:seeds/v2/images/vote/votes_down_arrow.dart';
import 'package:seeds/v2/images/vote/votes_up_arrow.dart';

class ProposalDetailsBottom extends StatelessWidget {
  const ProposalDetailsBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalDetailsBloc, ProposalDetailsState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: state.showNextButton
                  ? Column(
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
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Precast your Vote'.i18n, style: Theme.of(context).textTheme.headline7),
                        const SizedBox(height: 25.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CustomPaint(
                                    painter: const VotesUpArrow(
                                      circleColor: AppColors.lightGreen6,
                                      arrowColor: AppColors.white,
                                    ),
                                    child: InkResponse(
                                      onTap: () {
                                        BlocProvider.of<ProposalDetailsBloc>(context).add(const OnFavourButtonTapped());
                                      },
                                      child: Container(
                                        width: 65,
                                        height: 65,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text('Yes'.i18n, style: Theme.of(context).textTheme.button),
                                ],
                              ),
                              Column(
                                children: [
                                  CustomPaint(
                                    painter: const VotesAbstainSlash(),
                                    child: InkResponse(
                                      onTap: () {
                                        BlocProvider.of<ProposalDetailsBloc>(context)
                                            .add(const OnAbstainButtonTapped());
                                      },
                                      child: Container(
                                        width: 65,
                                        height: 65,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text('Abstain'.i18n, style: Theme.of(context).textTheme.button),
                                ],
                              ),
                              Column(
                                children: [
                                  CustomPaint(
                                    painter: const VotesDownArrow(
                                      circleColor: AppColors.darkGreen2,
                                      arrowColor: AppColors.white,
                                    ),
                                    child: InkResponse(
                                      onTap: () {
                                        BlocProvider.of<ProposalDetailsBloc>(context)
                                            .add(const OnAgainstButtonTapped());
                                      },
                                      child: Container(
                                        width: 65,
                                        height: 65,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text('No'.i18n, style: Theme.of(context).textTheme.button),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 50.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: FlatButtonLong(
                            enabled: state.isConfirmButtonEnabled,
                            title: 'Confirm'.i18n,
                            onPressed: () {
                              BlocProvider.of<ProposalDetailsBloc>(context).add(const OnConfirmButtonPressed());
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}
