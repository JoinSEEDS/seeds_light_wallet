import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_about.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_events.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_main_app_bar.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';

class RegionScreen extends StatelessWidget {
  const RegionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final region = ModalRoute.of(context)!.settings.arguments as RegionModel?;
    return BlocProvider(
      create: (_) => RegionBloc(region)..add(const OnRegionMounted()),
      child: Scaffold(
        body: BlocConsumer<RegionBloc, RegionState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            final command = state.pageCommand;
            if (command is NavigateToRoute) {
              NavigationService.of(context).pushAndRemoveUntil(route: command.route, from: Routes.app);
            }
          },
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, isInnerBoxScrolled) {
                      return [
                        const RegionMainAppBar(),
                        SliverPersistentHeader(
                          delegate: _SliverAppBarDelegate(
                            const TabBar(tabs: [Tab(text: "Events"), Tab(text: "About")]),
                          ),
                          pinned: true,
                        ),
                      ];
                    },
                    body: const TabBarView(children: [RegionEvents(), RegionAbout()]),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
