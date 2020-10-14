import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/connection_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/ecosystem/ecosystem.dart';
import 'package:seeds/screens/app/profile/profile.dart';
import 'package:seeds/screens/app/wallet/wallet.dart';
import 'package:seeds/i18n/widgets.i18n.dart';

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

class _AppState extends State<App> with WidgetsBindingObserver {
  final navigationTabs = [
    NavigationTab(
      title: "Explore".i18n,
      icon: 'assets/images/ecosystem.svg',
      screenBuilder: () => Ecosystem(),
      index: 0,
    ),
    NavigationTab(
      title: "Wallet".i18n,
      icon: 'assets/images/wallet.svg',
      screenBuilder: () => Wallet(),
      index: 1,
    ),
    NavigationTab(
      title: "Profile".i18n,
      icon: 'assets/images/profile.svg',
      screenBuilder: () => Profile(),
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
        case "Explore":
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
        setState(() {
          pageController.jumpToPage(
            pageIndex,
          );
          this.index = pageIndex;
        });
      }
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NavigationService.of(context).addListener(changePageNotifier);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        Provider.of<ConnectionNotifier>(context, listen: false)
            .discoverEndpoints();
        break;
      case AppLifecycleState.detached:
        break;
    }
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
    var svgPicture = SvgPicture.asset(
      'assets/images/qr-code.svg',
      color: Colors.black,
    );
    return AppBar(
      title: Text(
        navigationTabs[index].title,
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            icon: svgPicture,
            onPressed: () =>
                NavigationService.of(context).navigateTo(Routes.scanQRCode)),
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

  BottomNavigationBarItem buildIcon(String title, String icon, int tabIndex) {
    final width = MediaQuery.of(context).size.width * 0.21;
    return BottomNavigationBarItem(
        icon: Container(
          width: width,
          decoration: tabIndex == index
              ? BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.gradient),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)))
              : BoxDecoration(),
          padding: EdgeInsets.only(top: 7, left: 3, right: 3),
          child: SvgPicture.asset(
            icon,
            color: tabIndex == index ? Colors.white : AppColors.grey,
          ),
        ),
        // Note - wait for redesign of app to change this.
        // ignore: deprecated_member_use
        title: Container(
            width: width,
            alignment: Alignment.center,
            decoration: tabIndex == index
                ? BoxDecoration(
                    gradient: LinearGradient(colors: AppColors.gradient),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8)))
                : BoxDecoration(),
            padding: EdgeInsets.only(bottom: 5, top: 2, left: 3, right: 3),
            child: Text(
              title,
              style: TextStyle(
                  color: tabIndex == index ? Colors.white : AppColors.grey,
                  fontSize: 12),
            )));
  }

  Widget buildNavigation() {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (index) {
        switch (index) {
          case 0:
            changePageNotifier.add("Explore");
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
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedLabelStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
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
