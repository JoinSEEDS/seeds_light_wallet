import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote/interactor/viewmodels/bloc.dart';

/// VOTE SCREEN
class VoteScreen extends StatefulWidget {
  const VoteScreen({Key? key}) : super(key: key);

  @override
  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> with TickerProviderStateMixin {
  late VoteBloc _voteBloc;
  late TabController _tabController;

  @override
  void initState() {
    _voteBloc = VoteBloc();
    _tabController = TabController(length: _voteBloc.state.proposalTypes.length, vsync: this);
    _tabController.addListener(() {
      // Controller is finished animating --> get the current index
      if (!_tabController.indexIsChanging) {
        _voteBloc.add(OnTabChange(_tabController.index));
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
    return BlocProvider(
      create: (context) => _voteBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vote'),
          bottom: TabBar(
            controller: _tabController,
            tabs: _voteBloc.state.proposalTypes.keys.map((i) => Container(child: Text(i))).toList(),
          ),
        ),
        body: BlocBuilder<VoteBloc, VoteState>(
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return TabBarView(
                  controller: _tabController,
                  children: state.proposalTypes.values
                      .map((data) => Container(child: Center(child: Text(data['stage']))))
                      .toList(),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
