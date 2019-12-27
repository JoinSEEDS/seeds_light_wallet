import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:seeds/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:seeds/seedsButton.dart';

import './home.dart';
import './transfer.dart';
import './harvest.dart';
import './friends.dart';

import 'passcode.dart';

Future removeAccount() async {
  // final storage = new FlutterSecureStorage();
  // await storage.delete(key: "privateKey");

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("accountName");
  await prefs.remove("privateKey");
  await prefs.remove("passcode");
}

Future<String> getPasscode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString("passcode");
}

class App extends StatefulWidget {
  final String accountName;

  App(this.accountName);

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

  Future requirePasscode() async {
    String existingPasscode = await getPasscode();

    Future.delayed(Duration.zero, () {
      if (existingPasscode != null && existingPasscode != "") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UnlockWallet(existingPasscode),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LockWallet(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    requirePasscode();
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
          child: SeedsButton("Logout", () async {
            await removeAccount();

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => Onboarding(),
              ),
            );
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
        Home(movePage, this.widget.accountName),
        Transfer(this.widget.accountName),
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
