import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/explore_screens/vote/proposals/proposals.i18n.dart';

import 'interactor/viewmodels/bloc.dart';

class VoteAmountLabel extends StatelessWidget {
  final int proposalId;

  const VoteAmountLabel(this.proposalId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoteAmountLabelBloc()..add(LoadVoteAmount(proposalId)),
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
                      ? Text('+${state.amount} ' 'voted'.i18n,
                          style: Theme.of(context).textTheme.subtitle3OpacityEmphasisGreen)
                      : Text(
                          '${state.amount} ' 'voted'.i18n,
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
