import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/explore_screens/vote/vote.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/proposals_list.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/proposal_type_model.dart';

/// VOTE SCREEN
class VoteScreen extends StatelessWidget {
  const VoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoteBloc()..add(StartCycleCountdown()),
      child: DefaultTabController(
        length: proposalTypes.length,
        child: BlocBuilder<VoteBloc, VoteState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                actions: [
                  if (state.shouldShowDelegateIcon)
                    IconButton(
                      onPressed:
                          state.isCitizen ? () => NavigationService.of(context).navigateTo(Routes.delegate) : null,
                      icon: SvgPicture.asset('assets/images/explore/delegate.svg',
                          color: state.isCitizen ? null : AppColors.grey),
                    ),
                  const SizedBox(width: horizontalEdgePadding)
                ],
                title: Text('Vote'.i18n),
                shape: const Border(bottom: BorderSide(color: AppColors.lightGreen2)),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: TabBar(
                    indicatorWeight: 4.0,
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelStyle: Theme.of(context).textTheme.buttonOpacityEmphasis,
                    labelStyle: Theme.of(context).textTheme.buttonLowEmphasis,
                    tabs: [for (var i in proposalTypes) Tab(child: FittedBox(child: Text(i.type.i18n)))],
                  ),
                ),
              ),
              body: SafeArea(child: TabBarView(children: [for (var i in proposalTypes) ProposalsList(i)])),
            );
          },
        ),
      ),
    );
  }
}
