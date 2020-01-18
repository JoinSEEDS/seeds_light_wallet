import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/explorer/explorer.dart';
import 'package:seeds/screens/app/profile/profile.dart';
import 'package:seeds/screens/app/wallet/wallet.dart';
import 'package:seeds/widgets/seeds_button.dart';

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

class _AppState extends State<App> {
  final navigationTabs = [
    NavigationTab(
      title: "Explorer",
      icon: Icons.home,
      screenBuilder: () => Explorer(),
    ),
    NavigationTab(
      title: "Wallet",
      icon: Icons.account_balance_wallet,
      screenBuilder: () => Wallet(),
    ),
    NavigationTab(
      title: "Profile",
      icon: Icons.people,
      screenBuilder: () => Profile(),
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
        case "Proposals":
          pageIndex = 0;
          break;
        case "Invites":
          pageIndex = 0;
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
      title: Image.asset(
        'assets/images/seeds-logo-with-text.png',
        height: 40,
        alignment: Alignment.topLeft,
      ),
      centerTitle: false,
      actions: <Widget>[
        Container(
          child: SeedsButton("Logout", () {
            AuthNotifier.of(context).removeAccount();
          }, true),
          height: 20,
          margin: EdgeInsets.only(
            top: 20,
            right: 15,
          ),
        ),
      ],
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
