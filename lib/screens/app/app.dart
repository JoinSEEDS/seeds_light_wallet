import 'package:flutter/material.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/widgets/seeds_button.dart';
import 'package:seeds/screens/app/friends.dart';
import 'package:seeds/screens/app/home.dart';
import 'package:seeds/screens/app/transfer.dart';
import 'package:seeds/screens/app/proposals/proposals.dart';

class App extends StatefulWidget {
  App();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int index = 0;

  final navigationTitles = ["Dashboard", "Transfer", "Vote", "Invite"];
  final navigationIcons = [
    Icons.home,
    Icons.account_balance_wallet,
    Icons.event_note,
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
        Home(movePage),
        Transfer(),
        Proposals(),
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
