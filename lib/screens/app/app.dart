import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/viewmodels/auth.dart';
import 'package:seeds/widgets/seeds_button.dart';

import './home.dart';
import './transfer.dart';
import './harvest.dart';
import './friends.dart';

class App extends StatefulWidget {
  App();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int index = 0;

  final navigationTitles = ["Dashboard", "Transfer", "Harvest", "Friends"];
  final navigationIcons = [
    Icons.home,
    Icons.account_balance_wallet,
    Icons.settings_backup_restore,
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
      PageController(initialPage: 0, keepPage: true);

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
            Provider.of<AuthModel>(context, listen: false).removeAccount();
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
        Home(movePage),
        Transfer(),
        Harvest(),
        Friends(),
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
