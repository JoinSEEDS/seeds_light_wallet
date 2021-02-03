import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/features/scanner/telos_signing_manager.dart';
import 'package:seeds/i18n/widgets.i18n.dart';
import 'package:seeds/providers/notifiers/connection_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/links_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/ecosystem/ecosystem.dart';
import 'package:seeds/screens/app/profile/profile.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';
import 'package:seeds/screens/app/wallet/wallet.dart';
import 'package:seeds/widgets/pending_notification.dart';

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
      title: "Wallet".i18n,
      icon: 'assets/images/navigation_bar/wallet.svg',
      screenBuilder: () => Wallet(),
      index: 0,
    ),
    NavigationTab(
      title: "Explore".i18n,
      icon: 'assets/images/navigation_bar/explore.svg',
      screenBuilder: () => Ecosystem(),
      index: 1,
    ),
    NavigationTab(
      title: "Profile".i18n,
      icon: 'assets/images/navigation_bar/user_profile.svg',
      screenBuilder: () => Profile(),
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

    processSigningRequests();
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

  void processSigningRequests() {
    Provider.of<LinksService>(context, listen: false).listenSigningRequests((final link) async {
      if (link == null) {
        return;
      }

      var request = SeedsESR(uri: link);

      await request.resolve(
        account: SettingsNotifier.of(context, listen: false).accountName,
      );

      var action = request.actions.first;
      var data = Map<String, dynamic>.from(action.data);

      Navigator.of(context).push(
        PageRouteBuilder(
            opaque: false,
            fullscreenDialog: true,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              var tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
              var curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.bounceInOut,
              );

              return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child, // child is the value returned by pageBuilder
              );
            },
            pageBuilder: (BuildContext context, _, __) => CustomTransaction(CustomTransactionArguments(
                  account: action.account,
                  name: action.name,
                  data: data,
                ))),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFAFAFAFA),
      appBar: buildAppBar(context),
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
    );
  }

  Widget buildAppBar(BuildContext _context) {
    return AppBar(
      title: Text(navigationTabs[index].title),
      centerTitle: true,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 17),
          child: IconButton(
              icon: Icon(
                Icons.qr_code_scanner,
                size: 28,
              ),
              onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode)),
        ),
      ],
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

  BottomNavigationBarItem buildIcon(String title, String icon, int tabIndex, bool profileNotification) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 2),
          child: Stack(overflow: Overflow.visible, children: <Widget>[
            SvgPicture.asset(
              icon,
              color: tabIndex == index ? Colors.black : AppColors.grey,
            ),
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
        ),
        // Note - wait for redesign of app to change this.
        // ignore: deprecated_member_use
        title: tabIndex == index
            ? Icon(
                Icons.circle,
                size: 6,
              )
            : Icon(
                Icons.circle,
                size: 6,
                color: Colors.white,
              ));
  }

  Widget buildNavigation(bool showGuardianNotification) {
    return BottomNavigationBar(
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
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: navigationTabs
          .map(
            (tab) => buildIcon(tab.title, tab.icon, tab.index, showGuardianNotification),
          )
          .toList(),
    );
  }
}
