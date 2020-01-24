import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/explorer/explorer.dart';
import 'package:seeds/screens/app/profile/profile.dart';
import 'package:seeds/screens/app/wallet/wallet.dart';
import 'package:seeds/widgets/connection_status.dart';

class NavigationTab {
  final String title;
  final String icon;
  final Function screenBuilder;
  final int index;

  NavigationTab({this.title, this.icon, this.screenBuilder, this.index});
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
      icon: 'assets/images/explorer.svg',
      screenBuilder: () => ConnectionStatus(
        child: Explorer(),
      ),
      index: 0,
    ),
    NavigationTab(
      title: "Wallet",
      icon: 'assets/images/wallet.svg',
      screenBuilder: () => ConnectionStatus(
        child: Wallet(),
      ),
      index: 1,
    ),
    NavigationTab(
      title: "Profile",
      icon: 'assets/images/profile.svg',
      screenBuilder: () => ConnectionStatus(
        child: Profile(),
      ),
      index: 2,
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

  BottomNavigationBarItem buildIcon(String title, String icon, int tabIndex) {
    final width = MediaQuery.of(context).size.width * 0.21;
    return BottomNavigationBarItem(
      icon: Container(
        width: width,
        decoration: tabIndex == index ? BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradient
          ),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))
        ) : BoxDecoration(),
        padding: EdgeInsets.only(top: 7, left: 3, right: 3),
        child: SvgPicture.asset(icon,
          color: tabIndex == index ? Colors.white: AppColors.grey,
        ),
      ),
      title: Container(
        width: width,
        alignment: Alignment.center,
        decoration: tabIndex == index ? BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradient
          ),
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8))
        ) : BoxDecoration(),
        padding: EdgeInsets.only(bottom: 5, top: 2, left: 3, right: 3),
        child: Text(title,
          style: TextStyle(
            color: tabIndex == index ? Colors.white: AppColors.grey,
            fontSize: 12
          ),
        )
      )
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
      showUnselectedLabels: true,
      fixedColor: Colors.white,
      unselectedItemColor: AppColors.grey,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 12
      ),
      unselectedLabelStyle: TextStyle(
        color: Colors.grey.withOpacity(0.7)
      ),
      elevation: 9,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: navigationTabs
          .map(
            (tab) => buildIcon(tab.title, tab.icon, tab.index),
          )
          .toList(),
    );
  }
}
