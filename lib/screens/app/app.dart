import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teloswallet/constants/app_colors.dart';
import 'package:teloswallet/generated/r.dart';
import 'package:teloswallet/providers/services/navigation_service.dart';
import 'package:teloswallet/screens/app/tools/tools.dart';
import 'package:teloswallet/screens/app/scan/custom_transaction.dart';
import 'package:teloswallet/screens/app/scan/scan.dart';
import 'package:teloswallet/screens/app/scan/signing_request/get_readable_request.dart';
import 'package:teloswallet/screens/app/wallet/wallet.dart';
import 'package:uni_links/uni_links.dart';

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
  StreamSubscription requestSubscription;

  void processSigningRequest(String uriPath) async {
    Map<String, dynamic> signingRequest = await getReadableRequest(uriPath);

    var action = signingRequest['action'];
    var account = signingRequest['account'];
    var data = signingRequest['data'];

    NavigationService.of(context).navigateTo(
      Routes.customTransaction,
      CustomTransactionArguments(account: action, name: account, data: data),
      false,
    );
  }

  void listenSigningRequests() async {
    requestSubscription = getUriLinksStream().listen((Uri uri) {
      String uriPath = uri.path;

      processSigningRequest(uriPath);
    }, onError: (err) {});

    try {
      Uri initialUri = await getInitialUri();

      if (initialUri != null) {
        String uriPath = initialUri.path;

        processSigningRequest(uriPath);
      }
    } on FormatException {}
  }

  final navigationTabs = [
    NavigationTab(
      title: "Tools",
      icon: R.tools,
      screenBuilder: () => Tools(),
      index: 0,
    ),
    NavigationTab(
      title: "Wallet",
      icon: R.wallet,
      screenBuilder: () => Wallet(),
      index: 1,
    ),
    NavigationTab(
      title: "Scan QR",
      icon: R.scan,
      screenBuilder: () => Scan(),
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

    listenSigningRequests();

    changePageNotifier.stream.listen((page) {
      int pageIndex;

      switch (page) {
        case "Tools":
          pageIndex = 0;
          break;
        case "Wallet":
          pageIndex = 1;
          break;
        case "Scan":
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
  }

  @override
  void dispose() {
    super.dispose();
    requestSubscription.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
            changePageNotifier.add("Tools");
            break;
          case 1:
            changePageNotifier.add("Wallet");
            break;
          case 2:
            changePageNotifier.add("Scan");
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
