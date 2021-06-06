import 'package:flutter/material.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/screens/explore_screens/vote/components/proposals/proposals.dart';
import 'interactor/viewmodels/proposal_type_model.dart';
import 'package:seeds/v2/design/app_theme.dart';

/// VOTE SCREEN
class VoteScreen extends StatefulWidget {
  const VoteScreen({Key? key}) : super(key: key);

  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: proposalTypes.length, vsync: this);
    _tabController.addListener(() {
      // Controller is finished animating --> get the current index
      if (!_tabController.indexIsChanging) {
        // _voteBloc.add(OnTabChange(_tabController.index));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vote'),
        bottom: TabBar(
            labelPadding: const EdgeInsets.all(8.0),
            indicatorColor: AppColors.green1,
            indicatorSize: TabBarIndicatorSize.label,
            controller: _tabController,
            unselectedLabelStyle: Theme.of(context).textTheme.buttonOpacityEmphasis,
            labelStyle: Theme.of(context).textTheme.buttonLowEmphasis,
            tabs: [for (var i in proposalTypes) Tab(child: Text(i.type))]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: proposalTypes.map((i) => ProposalsList(proposalType: i)).toList(),
      ),
    );
  }
}
