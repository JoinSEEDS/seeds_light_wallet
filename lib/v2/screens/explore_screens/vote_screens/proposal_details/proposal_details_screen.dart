import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/components/proposal_details_bottom.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/components/proposal_details_header.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/components/proposal_details_middle.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_and_index.dart';
import 'package:flutter/material.dart';

class ProposalDetailsScreen extends StatefulWidget {
  const ProposalDetailsScreen({Key? key}) : super(key: key);

  @override
  _ProposalDetailsScreenState createState() => _ProposalDetailsScreenState();
}

class _ProposalDetailsScreenState extends State<ProposalDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProposalsAndIndex? proposalsAndIndex = ModalRoute.of(context)?.settings.arguments as ProposalsAndIndex?;
    return Scaffold(
      body: BlocProvider(
        create: (_) => ProposalDetailsBloc(proposalsAndIndex!)..add(const OnLoadProposalData()),
        child: BlocConsumer<ProposalDetailsBloc, ProposalDetailsState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (_, __) {
            _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return WillPopScope(
                  onWillPop: () async {
                    if (state.currentIndex != proposalsAndIndex!.index) {
                      Navigator.of(context).pop(state.currentIndex);
                    }
                    return true;
                  },
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      const ProposalDetailsHeader(),
                      const SliverList(
                        delegate: SliverChildListDelegate.fixed([ProposalDetailsMiddle(), ProposalDetailsBottom()]),
                      ),
                    ],
                  ),
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
