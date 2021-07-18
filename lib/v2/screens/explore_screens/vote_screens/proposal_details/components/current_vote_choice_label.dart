import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/i18n/explore_screens/vote/proposals/proposals_details.i18n.dart';
import '../interactor/viewmodels/proposal_details_bloc.dart';

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
                      TextSpan(text: "I'm".i18n, style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(text: ' in favor '.i18n, style: Theme.of(context).textTheme.subtitle2Green2),
                      TextSpan(text: 'of this proposal with '.i18n, style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(text: state.voteAmount.toString(), style: Theme.of(context).textTheme.subtitle2),
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
                      TextSpan(text: 'I'.i18n, style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(text: ' refrain '.i18n, style: Theme.of(context).textTheme.subtitle2Green2),
                      TextSpan(text: 'from voting'.i18n, style: Theme.of(context).textTheme.subtitle2),
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
                      TextSpan(text: "I'm".i18n, style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(text: ' against '.i18n, style: Theme.of(context).textTheme.subtitle2Green2),
                      TextSpan(text: 'this proposal with '.i18n, style: Theme.of(context).textTheme.subtitle2),
                      TextSpan(text: state.voteAmount.toString(), style: Theme.of(context).textTheme.subtitle2),
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
