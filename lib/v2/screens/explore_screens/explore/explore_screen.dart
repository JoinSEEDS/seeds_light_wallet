import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:seeds/v2/screens/explore_screens/explore/components/explore_link_card.dart';
import 'package:seeds/v2/screens/explore_screens/explore/components/explore_card.dart';
import 'package:seeds/v2/screens/explore_screens/explore/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/i18n/explore_screens/explore/explore.i18n.dart';

/// Explore SCREEN
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) => ExploreBloc()..add(const LoadExploreData()),
      child: Scaffold(
        appBar: AppBar(title: Text('Explore'.i18n)),
        body: BlocConsumer<ExploreBloc, ExploreState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            var pageCommand = state.pageCommand;
            BlocProvider.of<ExploreBloc>(context)..add(const ClearExplorePageCommand());
            if (pageCommand is NavigateToRoute) {
              NavigationService.of(context).navigateTo(pageCommand.route);
            }
          },
          builder: (context, ExploreState state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return Stack(
                  children: [
                    Container(
                      height: height,
                      child: ListView(
                        padding: const EdgeInsets.all(horizontalEdgePadding),
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ExploreCard(
                                  onTap: () {
                                    BlocProvider.of<ExploreBloc>(context).add(OnExploreCardTapped(Routes.createInvite));
                                  },
                                  title: 'Invite a Friend'.i18n,
                                  icon: SvgPicture.asset(
                                    'assets/images/explore/person_send_invite.svg',
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ExploreCard(
                                  onTap: () {
                                    BlocProvider.of<ExploreBloc>(context).add(OnExploreCardTapped(Routes.plantSeeds));
                                  },
                                  title: 'Planted Seeds'.i18n,
                                  icon: SvgPicture.asset('assets/images/explore/plant_seed.svg'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: ExploreCard(
                                  onTap: () {
                                    BlocProvider.of<ExploreBloc>(context).add(OnExploreCardTapped(Routes.vote));
                                  },
                                  title: 'Vote'.i18n,
                                  icon: SvgPicture.asset('assets/images/explore/thumb_up.svg'),
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Expanded(child: SizedBox.shrink()),
                            ],
                          ),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(horizontalEdgePadding),
                        child: Row(
                          children: [
                            Expanded(
                              child: ExploreLinkCard(
                                backgroundImage: 'assets/images/explore/get_seeds_card.jpg',
                                onTap: () =>
                                    launch('$url_buy_seeds${settingsStorage.accountName}', forceSafariVC: false),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: state.isDHOMember
                                  ? ExploreLinkCard(
                                      backgroundImage: 'assets/images/explore/hypha_dho_card.jpg',
                                      onTap: () => NavigationService.of(context).navigateTo(Routes.dho),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
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
