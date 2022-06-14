import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/components/confirm_vote_dialog.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/components/proposal_details_bottom.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/components/proposal_details_header.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/components/proposal_details_middle.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/components/vote_success_dialog.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/proposal_details_bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_args_data.dart';

class ProposalDetailsScreen extends StatefulWidget {
  const ProposalDetailsScreen({super.key});

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
    final ProposalsArgsData? proposalsArgsData = ModalRoute.of(context)?.settings.arguments as ProposalsArgsData?;
    return Scaffold(
      body: BlocProvider(
        create: (_) => ProposalDetailsBloc(proposalsArgsData!)..add(const OnLoadProposalData()),
        child: BlocConsumer<ProposalDetailsBloc, ProposalDetailsState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) async {
            final pageCommand = state.pageCommand;
            // Delay to avoid error when list is not drawed yet
            // because of (loading->success) transition
            if (pageCommand is ReturnToTopScreen) {
              await Future.delayed(const Duration(microseconds: 500));
              await _scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            } else if (pageCommand is ShowConfimVote) {
              final bool? isConfirmed = await showDialog<bool?>(
                context: context,
                barrierDismissible: false,
                builder: (_) => const ConfirmVoteDialog(),
              );
              if (isConfirmed != null && isConfirmed) {
                // ignore: use_build_context_synchronously
                BlocProvider.of<ProposalDetailsBloc>(context).add(const OnConfirmVoteButtonPressed());
              }
            } else if (pageCommand is VoteSuccess) {
              await showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) => const VoteSuccessDialog(),
              );
            }
          },
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return WillPopScope(
                  onWillPop: () async {
                    if (state.currentIndex != proposalsArgsData!.index) {
                      Navigator.of(context).pop(state.currentIndex);
                    }
                    return true;
                  },
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      const ProposalDetailsHeader(),
                      const ProposalDetailsMiddle(),
                      const ProposalDetailsBottom()
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
