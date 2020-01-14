import 'package:flutter/material.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/services/auth_service.dart';
import 'package:seeds/widgets/passcode.dart';
import 'package:seeds/widgets/seeds_button.dart';

import './friends.dart';
import './home.dart';
import './transfer.dart';
import 'proposals/proposals.dart';
import 'package:flutter_offline/flutter_offline.dart';

class App extends StatefulWidget {
  final String accountName;

  App(this.accountName);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final AuthService authService = AuthService();

  int index = 0;

  final navigationTitles = ["Dashboard", "Transfer", "Vote", "Invite"];
  final navigationIcons = [
    Icons.home,
    Icons.account_balance_wallet,
    Icons.event_note,
    Icons.people
  ];

  Future requirePasscode() async {
    String existingPasscode = await authService.getPasscode();

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
          body: buildPageView('check_on_off'),
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
            await authService.removeAccount();

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

  Widget buildPageView(String type_page) {
    if (type_page == 'check_on_off') {     
        return  new Scaffold(
              body: OfflineBuilder(
                connectivityBuilder: (
                  BuildContext context,
                  ConnectivityResult connectivity,
                  Widget child,
                ) {
                  final bool connected = connectivity != ConnectivityResult.none;
                  if (connected == false) {
                        print('Connection is off...');
                        return new Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              height: 24.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                color: connected ? Color(0xFF00EE44) : Color(0xFFEE4400),
                                child: Center(
                                  child: Text("${connected ? 'ONLINE' : 'OFFLINE'}"),
                                ),
                              ),
                            ),
                            Center(
                              child: new Text(
                                'Check connection!',
                                 style: new TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                } else {
                    return _PageView();
                }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'Just turn on your internet.',
                    ),
                  ],
                ),
              ),
    );
    } else {
            print('Connection is working...');
            return _PageView();
    };
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

  _PageView() {
    return PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Home(movePage, this.widget.accountName),
                Transfer(this.widget.accountName),
                Proposals(),
                Friends(),
              ],
            );
  }
}
