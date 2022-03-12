import 'package:flutter/material.dart';

class RegionScreen extends StatefulWidget {
  const RegionScreen({Key? key}) : super(key: key);

  @override
  _RegionScreenState createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                actions: [
                  TextButton(
                    child: const Text("Join"),
                    onPressed: () {},
                  )
                ],
                expandedHeight: 200.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    title: const Text("state.regionAddress"),
                    background: Image.network(
                      "https://picsum.photos/400/300",
                      fit: BoxFit.cover,
                    )),
              ),
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
          body: const Center(
            child: Text("Sample text"),
          ),
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
