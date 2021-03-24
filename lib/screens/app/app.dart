import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/widgets.i18n.dart';
import 'package:seeds/providers/notifiers/connection_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/ecosystem/ecosystem.dart';
import 'package:seeds/screens/app/wallet/wallet.dart';
import 'package:seeds/v2/screens/profile_screens/profile/profile_screen.dart';
import 'package:seeds/widgets/pending_notification.dart';

import 'process_dynamic_links.dart';

class NavigationTab {
  final String title;
  final String icon;
  final String iconSelected;
  final Function screenBuilder;
  final int index;

  NavigationTab({this.title, this.icon, this.iconSelected, this.screenBuilder, this.index});
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
      title: "Wallet".i18n,
      icon: 'assets/images/navigation_bar/wallet.svg',
      iconSelected: 'assets/images/navigation_bar/wallet_selected.svg',
      screenBuilder: () => Wallet(),
      index: 0,
    ),
    NavigationTab(
      title: "Explore".i18n,
      icon: 'assets/images/navigation_bar/explore.svg',
      iconSelected: 'assets/images/navigation_bar/explore_selected.svg',
      screenBuilder: () => Ecosystem(),
      index: 1,
    ),
    NavigationTab(
      title: "Profile".i18n,
      icon: 'assets/images/navigation_bar/user_profile.svg',
      iconSelected: 'assets/images/navigation_bar/user_profile_selected.svg',
      screenBuilder: () => ProfileScreen(),
      index: 2,
    ),
  ];

  final StreamController<String> changePageNotifier = StreamController<String>.broadcast();

  int index = 0;
  PageController pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();

    changePageNotifier.stream.listen((page) {
      int pageIndex;

      switch (page) {
        case "Wallet":
          pageIndex = 0;
          break;
        case "Explore":
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
        Provider.of<ConnectionNotifier>(context, listen: false).discoverEndpoints();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProcessDynamicLinks(
      child: Scaffold(
        body: buildPageView(),
        bottomNavigationBar: StreamBuilder<bool>(
            stream: FirebaseDatabaseService()
                .hasGuardianNotificationPending(SettingsNotifier.of(context, listen: false).accountName),
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot != null && snapshot.hasData) {
                return buildNavigation(snapshot.data);
              } else {
                return buildNavigation(false);
              }
            }),
      ),
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

  BottomNavigationBarItem buildIcon(
      String title, String icon, String selectedIcon, bool isSelected, bool profileNotification) {
    return BottomNavigationBarItem(
      activeIcon: SvgPicture.asset(selectedIcon, height: 24, width: 24),
      icon: Stack(overflow: Overflow.visible, children: <Widget>[
        SvgPicture.asset(icon, height: 24, width: 24),
        title == "Profile"
            ? profileNotification
                ? Positioned(
                    child: guardianNotification(profileNotification),
                    right: 6,
                    top: 2,
                  )
                : SizedBox.shrink()
            : SizedBox.shrink()
      ]),
      title: isSelected
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(title, style: Theme.of(context).textTheme.caption),
            )
          : SizedBox.shrink(),
    );
  }

  Widget buildNavigation(bool showGuardianNotification) {
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.white, width: 0.2))),
      child: BottomNavigationBar(
        currentIndex: index,
        onTap: (index) {
          switch (index) {
            case 0:
              changePageNotifier.add("Wallet");
              break;
            case 1:
              changePageNotifier.add("Explore");
              break;
            case 2:
              changePageNotifier.add("Profile");
              break;
          }
        },
        items: navigationTabs
            .map(
              (tab) => buildIcon(tab.title, tab.icon, tab.iconSelected, tab.index == index, showGuardianNotification),
            )
            .toList(),
      ),
    );
  }
}
