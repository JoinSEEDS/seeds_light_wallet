import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/explorer/explorer.dart';
import 'package:seeds/screens/app/profile/profile.dart';
import 'package:seeds/screens/app/wallet/wallet.dart';
import 'package:seeds/widgets/connection_status.dart';

class NavigationTab {
  final String title;
  final IconData icon;
  final Function screenBuilder;

  NavigationTab({this.title, this.icon, this.screenBuilder});
}

class App extends StatefulWidget {
  App();

  @override
  _AppState createState() => _AppState();
}

bool connected = true;

class _AppState extends State<App> {
  final navigationTabs = [
    NavigationTab(
      title: "Explorer",
      icon: Icons.home,
      screenBuilder: () => ConnectionStatus(
        child: Explorer(),
      ),
    ),
    NavigationTab(
      title: "Wallet",
      icon: Icons.account_balance_wallet,
      screenBuilder: () => ConnectionStatus(
        child: Wallet(),
      ),
    ),
    NavigationTab(
      title: "Profile",
      icon: Icons.people,
      screenBuilder: () => ConnectionStatus(
        child: Profile(),
      ),
    ),
  ];

  final StreamController<String> changePageNotifier =
      StreamController<String>.broadcast();

  int index = 1;
  PageController pageController =
      PageController(initialPage: 1, keepPage: true);

  @override
  void initState() {
    super.initState();

    changePageNotifier.stream.listen((page) {
      int pageIndex;

      switch (page) {
        case "Explorer":
          pageIndex = 0;
          break;
        case "Wallet":
          pageIndex = 1;
          break;
        case "Profile":
          pageIndex = 2;
          break;
      }

      if (pageIndex != null) {
        print("JUMP TO $pageIndex");
        setState(() {
          pageController.jumpToPage(
            pageIndex,
          );
          this.index = pageIndex;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("app changed dependencies");
    NavigationService.of(context).addListener(changePageNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFAFAFAFA),
        appBar: buildAppBar(context),
        body: buildPageView(),
        bottomNavigationBar: buildNavigation(),
      ),
    );
  }

  Widget buildAppBar(BuildContext _context) {
    return AppBar(
      title: Text(
        navigationTabs[index].title,
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        ...navigationTabs.map((tab) => tab.screenBuilder()).toList(),
      ],
    );
  }

  Widget buildNavigation() {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (index) {
        switch (index) {
          case 0:
            changePageNotifier.add("Explorer");
            break;
          case 1:
            changePageNotifier.add("Wallet");
            break;
          case 2:
            changePageNotifier.add("Profile");
            break;
        }
      },
      elevation: 9,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      items: navigationTabs
          .map(
            (tab) => BottomNavigationBarItem(
              icon: Icon(tab.icon),
              title: Text(tab.title),
            ),
          )
          .toList(),
    );
  }
}
