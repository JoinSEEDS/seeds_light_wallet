import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:seeds/app.dart';
import 'package:seeds/seedsButton.dart';

import 'customColors.dart';

PageViewModel page({bubble, mainImage, body, title}) {
  return PageViewModel(
    bubble: Icon(bubble),
    mainImage: Image.asset(
      mainImage,
      height: 285.0,
      width: 285.0,
      alignment: Alignment.center,
    ),
    body: Text(body),
    title: Center(
      child: Text(title),
    ),
    pageColor: const Color(0xFF24b0d6),
    titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
    bodyTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
  );
}

class MaterialPopupScreen extends StatelessWidget {
  final String title;
  final Widget body;

  MaterialPopupScreen({this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              title,
              style: TextStyle(fontFamily: "worksans", color: Colors.black),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    CommunityMaterialIcons.close_circle,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
              padding: EdgeInsets.only(bottom: 5),
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}

class ImportPrivateKey extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialPopupScreen();
  }
}

class ScanCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ImportScanChoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialPopupScreen(
      title: "Import account / Scan Invite",
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
        padding: EdgeInsets.only(bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Do you have account already?",
              style: TextStyle(
                fontFamily: "worksans",
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: SeedsButton(
                "Import private key",
                () {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Do you have invite?",
              style: TextStyle(
                fontFamily: "worksans",
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: SeedsButton(
                "Scan QR Code",
                () {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "You can ask for invite from other SEEDS member or subscribe for next campaign at joinseeds.com",
              style: TextStyle(
                color: Colors.black45,
                fontFamily: "worksans",
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Membership based on Web of Trust",
                style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "worksans",
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<PageViewModel> pages = [
    page(
      bubble: Icons.account_balance_wallet,
      mainImage: 'assets/images/onboarding1.png',
      body:
          'Make global payments with zero fees - receive cashback for positive impact of your transactions',
      title: 'Better than free transactions',
    ),
    page(
        bubble: Icons.settings_backup_restore,
        mainImage: 'assets/images/onboarding2.png',
        body:
            'Plant Seeds for benefit of sustainable organizations - participate in harvest distribution',
        title: 'Plant Seeds - get Seeds'),
    page(
        bubble: Icons.people,
        mainImage: 'assets/images/onboarding3.png',
        body:
            'Connect with other members and get funded for positive social and environmental contributions',
        title: 'Cooperative Economy'),
  ];

  bool done = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "JOIN NOW",
        home: Builder(
          builder: (context) => IntroViewsFlutter(
            pages,
            key: new UniqueKey(),
            onTapSkipButton: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => App(),
                ),
              );
            },
            onTapDoneButton: () async {
              if (done) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => App(), 
                  ),
                );

                return;
              }

              final success = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ImportScanChoice(),
                ),
              );

              if (success) {
                setState(() {
                  done = true;
                  pages = [
                    page(
                      bubble: Icons.done,
                      mainImage: 'assets/images/onboarding4.png',
                      body:
                          'Your account testingseeds has been created on blockchain',
                      title: 'Welcome to SEEDS',
                    ),
                  ];
                });
              }
            },
            doneButtonPersist: true,
            doneText: Text(
              done ? "SHOW APP" : "JOIN NOW",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "worksans",
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            showNextButton: true,
            showBackButton: true,
            pageButtonTextStyles: TextStyle(
              fontFamily: "worksans",
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ));
  }
}
