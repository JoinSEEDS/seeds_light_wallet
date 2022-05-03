import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/proposal_details_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class CurrentVoteChoiceLabel extends StatelessWidget {
  const CurrentVoteChoiceLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalDetailsBloc, ProposalDetailsState>(
      builder: (context, state) {
        if (state.voteAmount > 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 28.0, left: horizontalEdgePadding, bottom: 10),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: context.loc.proposalDetailsInFavor1, style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(
                          text: context.loc.proposalDetailsInFavor2,
                          style: Theme.of(context).textTheme.subtitle2Green2),
                      TextSpan(text: context.loc.proposalDetailsInFavor3, style: Theme.of(context).textTheme.subtitle2),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state.voteAmount == 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 28.0, left: horizontalEdgePadding, bottom: 10),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: context.loc.proposalDetailsRefrain1, style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(
                          text: context.loc.proposalDetailsRefrain2,
                          style: Theme.of(context).textTheme.subtitle2Green2),
                      TextSpan(text: context.loc.proposalDetailsRefrain3, style: Theme.of(context).textTheme.subtitle2),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state.voteAmount < 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 28.0, left: horizontalEdgePadding, bottom: 10),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: context.loc.proposalDetailsInFavor1, style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(
                          text: context.loc.proposalDetailsAgainst2,
                          style: Theme.of(context).textTheme.subtitle2Green2),
                      TextSpan(text: context.loc.proposalDetailsAgainst3, style: Theme.of(context).textTheme.subtitle2),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(height: 50.0);
        }
      },
    );
  }
}
