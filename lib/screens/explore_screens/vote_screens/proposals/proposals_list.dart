import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/components/loading_indicator_list.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/components/proposal_card.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/components/voting_end_cycle_card.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_args_data.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_list_bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/vote_bloc.dart';

class ProposalsList extends StatefulWidget {
  final ProposalType proposalType;

  const ProposalsList(this.proposalType, {super.key});

  @override
  _ProposalsListState createState() => _ProposalsListState();
}

class _ProposalsListState extends State<ProposalsList> with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  late ProposalsListBloc _proposalsBloc;

  @override
  void initState() {
    _proposalsBloc = ProposalsListBloc(widget.proposalType);
    _scrollController.addListener(() {
      // if scroll to bottom of list, then load next proposals batch
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !_proposalsBloc.state.hasReachedMax) {
        _proposalsBloc.add(const OnUserProposalsScroll());
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        print('Screen not mounted --> call avoided.');
        return;
      }
      _proposalsBloc.add(const InitialLoadProposals());
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => _proposalsBloc,
      child: BlocConsumer<ProposalsListBloc, ProposalsListState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) async {
          final pageCommand = state.pageCommand;
          _proposalsBloc.add(const ClearProposalsListPageCommand());
          if (pageCommand is NavigateToRouteWithArguments<ProposalsArgsData>) {
            final args = pageCommand.arguments
                .copyWith(currentDelegates: BlocProvider.of<VoteBloc>(context).state.currentDelegates);
            final int? index = await NavigationService.of(context).navigateTo(pageCommand.route, args) as int?;
            if (index != null) {
              // 420 is the height of this proposal card
              // ignore: unawaited_futures
              _scrollController.animateTo(420.0 * index,
                  duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
            }
          }
        },
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.loading:
              return const FullPageLoadingIndicator();
            case PageState.failure:
              return const FullPageErrorIndicator();
            case PageState.success:
              return RefreshIndicator(
                onRefresh: () async => _proposalsBloc.add(const OnUserProposalsRefresh()),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    if (widget.proposalType.index == 0 || widget.proposalType.index == 1)
                      const SliverPersistentHeader(floating: true, delegate: VotingCycleEndCard()),
                    if (state.proposals.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Text('No proposals to show, yet', style: Theme.of(context).textTheme.button),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.only(
                            top: widget.proposalType.index != 0 && widget.proposalType.index != 1 ? 16 : 0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index >= state.proposals.length) {
                                return const LoadingIndicatorList();
                              } else {
                                return ProposalCard(
                                  proposal: state.proposals[index],
                                  onTap: () => _proposalsBloc.add(OnProposalCardTapped(index)),
                                );
                              }
                            },
                            childCount: state.hasReachedMax ? state.proposals.length : state.proposals.length + 1,
                          ),
                        ),
                      ),
                  ],
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
