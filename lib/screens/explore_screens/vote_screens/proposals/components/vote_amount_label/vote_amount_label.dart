import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/components/vote_amount_label/interactor/viewmodels/vote_amount_label_bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';
import 'package:seeds/utils/build_context_extension.dart';

class VoteAmountLabel extends StatelessWidget {
  final ProposalViewModel proposal;

  const VoteAmountLabel(this.proposal, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoteAmountLabelBloc()..add(LoadVoteAmount(proposal)),
      child: BlocBuilder<VoteAmountLabelBloc, VoteAmountLabelState>(
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.initial:
            case PageState.failure:
              return const SizedBox.shrink();
            case PageState.loading:
              return Container(
                width: 60.0,
                height: 22.0,
                decoration: BoxDecoration(color: AppColors.darkGreen3, borderRadius: BorderRadius.circular(6.0)),
                child: const Center(
                    child: SizedBox(width: 14.0, height: 14.0, child: CircularProgressIndicator(strokeWidth: 2))),
              );
            case PageState.success:
              return Container(
                decoration: BoxDecoration(color: AppColors.darkGreen3, borderRadius: BorderRadius.circular(6.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: state.amount > 0
                      ? Text(context.loc.proposalAmountVotedPositive(state.amount),
                          style: Theme.of(context).textTheme.subtitle3OpacityEmphasisGreen)
                      : Text(
                          context.loc.proposalAmountVotedZeroOrNegative(state.amount),
                          style: state.amount == 0
                              ? Theme.of(context).textTheme.subtitle3Opacity
                              : Theme.of(context).textTheme.subtitle3OpacityEmphasisRed,
                        ),
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
