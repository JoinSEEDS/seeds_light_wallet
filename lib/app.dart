import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import './home.dart';
import './transfer.dart';
import './harvest.dart';
import './friends.dart';

import './customColors.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int index = 0;

  final navigationTitles = ["Dashboard", "Transfer", "Harvest", "Friends"];
  final navigationIcons = [Icons.home, Icons.account_balance_wallet, Icons.settings_backup_restore, Icons.people];

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
      PageController(initialPage: 0, keepPage: true);

  void movePage(index) {
    setState(() {
      print('set state');
      print(index);
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFAFAFAFA),
      appBar: buildAppBar(),
      body: buildPageView(),
      bottomNavigationBar: buildNavigation(),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Image.asset(
        'assets/images/seeds-logo-with-text.png',
        height: 40,
        alignment: Alignment.topLeft,
      ),
      centerTitle: false,
      actions: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            right: 15,
          ),
          child: Image.asset(
            'assets/images/icon_school-bell.png',
            color: CustomColors.Green,
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
        Home(movePage),
        Transfer(),
        Harvest(),
        Friends(),
      ],
    );
  }

  Widget buildNavigation() {
    print('rebuild navigation');
    print(index);

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
