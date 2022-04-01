import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/region_main_app_bar.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/tab_about.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/tab_events.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/tab_messages.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';

class RegionScreen extends StatefulWidget {
  const RegionScreen({Key? key}) : super(key: key);

  @override
  _RegionScreenState createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  @override
  Widget build(BuildContext context) {
    final region = ModalRoute.of(context)!.settings.arguments as RegionModel?;
    return BlocProvider(
      create: (_) => RegionBloc(region),
      child: Scaffold(
        body: BlocBuilder<RegionBloc, RegionState>(
          builder: (context, state) {
            return DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder: (context, isInnerBoxScrolled) {
                  return [
                    const RegionMainAppBar(),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        const TabBar(
                          tabs: [
                            Tab(text: "Chat"),
                            Tab(text: "Events"),
                            Tab(text: "About"),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: const SafeArea(child: TabBarView(children: [MessagesTab(), EventsTab(), AboutTab()])),
              ),
            );
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
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
