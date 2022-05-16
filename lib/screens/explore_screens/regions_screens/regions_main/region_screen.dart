import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_about.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_events.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_main_app_bar.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';

class RegionScreen extends StatelessWidget {
  const RegionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final region = ModalRoute.of(context)!.settings.arguments as RegionModel?;
    return BlocProvider(
      create: (_) => RegionBloc(region)..add(const OnRegionMounted()),
      child: BlocConsumer<RegionBloc, RegionState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final command = state.pageCommand;
          if (command is NavigateToRoute) {
            NavigationService.of(context).pushAndRemoveUntil(route: command.route, from: Routes.app);
          } else if (command is NavigateToRouteWithArguments) {
            NavigationService.of(context).navigateTo(command.route, command.arguments);
          }
          BlocProvider.of<RegionBloc>(context).add(const ClearRegionPageCommand());
        },
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.failure:
              return const Scaffold(body: FullPageErrorIndicator());
            case PageState.success:
              return Scaffold(
                body: DefaultTabController(
                  length: 2,
                  child: SafeArea(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, isInnerBoxScrolled) {
                        return [
                          const RegionMainAppBar(),
                          const SliverPersistentHeader(delegate: _SliverAppBarDelegate(), pinned: true),
                        ];
                      },
                      body: const TabBarView(children: [RegionEvents(), RegionAbout()]),
                    ),
                  ),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  const _SliverAppBarDelegate();

  @override
  double get minExtent => tabHeight;

  @override
  double get maxExtent => tabHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: AppColors.primary, child: const TabBar(tabs: [Tab(text: "Events"), Tab(text: "About")]));
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
