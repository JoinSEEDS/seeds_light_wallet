import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/i18n/explore_screens/vote/vote.i18n.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/proposals_list.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

/// VOTE SCREEN
class VoteScreen extends StatelessWidget {
  const VoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoteBloc()..add(StartCycleCountdown()),
      child: DefaultTabController(
        length: proposalTypes.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Vote'.i18n),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.lightGreen2)),
                ),
                child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelStyle: Theme.of(context).textTheme.buttonOpacityEmphasis,
                    labelStyle: Theme.of(context).textTheme.buttonLowEmphasis,
                    tabs: [for (var i in proposalTypes) Tab(child: FittedBox(child: Text(i.type.i18n)))]),
              ),
            ),
          ),
          body: TabBarView(children: [for (var i in proposalTypes) ProposalsList(i)]),
        ),
      ),
    );
  }
}
