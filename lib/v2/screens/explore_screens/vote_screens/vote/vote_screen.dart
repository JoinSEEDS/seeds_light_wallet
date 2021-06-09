import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/proposals_list.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

/// VOTE SCREEN
class VoteScreen extends StatelessWidget {
  const VoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: proposalTypes.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vote'),
          bottom: TabBar(
              labelPadding: const EdgeInsets.all(8.0),
              indicatorColor: AppColors.green1,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelStyle: Theme.of(context).textTheme.buttonOpacityEmphasis,
              labelStyle: Theme.of(context).textTheme.buttonLowEmphasis,
              tabs: [for (var i in proposalTypes) Tab(child: Text(i.type))]),
        ),
        body: TabBarView(children: [for (var i in proposalTypes) ProposalsList(proposalType: i)]),
      ),
    );
  }
}
