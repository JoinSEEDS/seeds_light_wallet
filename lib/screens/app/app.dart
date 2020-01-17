import 'package:flutter/material.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/screens/app/explorer/explorer.dart';
import 'package:seeds/screens/app/profile/profile.dart';
import 'package:seeds/screens/app/wallet/wallet.dart';
import 'package:seeds/widgets/seeds_button.dart';

class App extends StatefulWidget {
  App();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int index = 1;

  final navigationTitles = ["Explorer", "Wallet", "Profile"];
  final navigationIcons = [
    Icons.home,
    Icons.account_balance_wallet,
    Icons.people
  ];

  @override
  void initState() {
    super.initState();
  }

  List<BottomNavigationBarItem> buildNavigationItems() {
    List<BottomNavigationBarItem> items = [];

    for (var i = 0; i < navigationTitles.length; i++) {
      items.add(BottomNavigationBarItem(
        icon: Icon(navigationIcons[i]),
        title: Text(navigationTitles[i]),
      ));
    }

    return items;
  }

  PageController pageController =
      PageController(initialPage: 1, keepPage: true);

  void movePage(index) {
    setState(() {
      pageController.jumpToPage(
        index,
      );
      this.index = index;
    });
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
        Explorer(),
        Wallet(),
        Profile(),
      ],
    );
  }

  Widget buildNavigation() {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (index) {
        movePage(index);
      },
      elevation: 9,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      items: buildNavigationItems(),
    );
  }
}
