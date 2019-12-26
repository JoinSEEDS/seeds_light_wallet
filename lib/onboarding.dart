import 'dart:async';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:seeds/app.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:seeds/fullscreenLoader.dart';
import 'package:seeds/seedsButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:eosdart/eosdart.dart' as EOS;

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future saveAccount(String accountName, String privateKey) async {
  // final storage = new FlutterSecureStorage();
  // await storage.write(key: "privateKey", value: privateKey);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("accountName", accountName);
  await prefs.setString("privateKey", privateKey);
}

String applicationAccount = DotEnv().env['APPLICATION_ACCOUNT_NAME'];
String applicationPrivateKey = DotEnv().env['APPLICATION_PRIVATE_KEY'];
String debugAccount = DotEnv().env['DEBUG_ACCOUNT_NAME'];
String debugPrivateKey = DotEnv().env['DEBUG_PRIVATE_KEY'];
String debugInviteSecret = DotEnv().env['DEBUG_INVITE_SECRET'];
String debugInviteLink = DotEnv().env['DEBUG_INVITE_LINK'];

bool isDebugMode() => debugAccount != "" && debugPrivateKey != "";

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

class OverlayPopupScreen extends StatelessWidget {
  final String title;
  final Widget body;

  OverlayPopupScreen({this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            title,
            style: TextStyle(
                fontFamily: "worksans",
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          actions: <Widget>[
            if (Navigator.of(context).canPop())
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
    );
  }
}

class ClaimCode extends StatefulWidget {
  @override
  _ClaimCodeState createState() => _ClaimCodeState();
}

class _ClaimCodeState extends State<ClaimCode> {
  var inviteCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return OverlayPopupScreen(
      title: "Claim code",
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    "Invite code",
                    style: TextStyle(fontFamily: "sfprotext"),
                  ),
                ),
                Spacer(flex: 1),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: TextField(
                    textAlign: TextAlign.left,
                    showCursor: true,
                    enableInteractiveSelection: true,
                    autofocus: true,
                    controller: inviteCodeController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: "sfprotext",
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: SeedsButton("Accept invite", () async {
                String inviteCode = inviteCodeController.value.text;

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => CreateAccount(inviteCode)),
                );
              }),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: SeedsButton("Paste from clipboard", () async {
                ClipboardData clipboardData =
                    await Clipboard.getData('text/plain');
                String inviteCodeClipboard = clipboardData?.text ?? '';
                inviteCodeController.text = inviteCodeClipboard;
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ImportAccount extends StatefulWidget {
  @override
  _ImportAccountState createState() => _ImportAccountState();
}

class _ImportAccountState extends State<ImportAccount> {
  var accountNameController = MaskedTextController(
      text: debugAccount,
      mask: '@@@@@@@@@@@@',
      translator: {'@': new RegExp(r'[a-z1234]')});

  var privateKeyController = TextEditingController(text: debugPrivateKey);

  bool progress = false;

  @override
  Widget build(BuildContext context) {
    return OverlayPopupScreen(
      title: "Import account",
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    "Private key",
                    style: TextStyle(fontFamily: "sfprotext"),
                  ),
                ),
                Spacer(flex: 1),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: TextField(
                    textAlign: TextAlign.left,
                    showCursor: true,
                    enableInteractiveSelection: true,
                    autofocus: true,
                    controller: privateKeyController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: "sfprotext",
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  flex: 4,
                  child: Text(
                    "Account name",
                    style: TextStyle(fontFamily: "sfprotext"),
                  ),
                ),
                Spacer(flex: 1),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 3,
                  child: TextField(
                    textAlign: TextAlign.left,
                    showCursor: true,
                    enableInteractiveSelection: true,
                    autofocus: true,
                    controller: accountNameController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: "sfprotext",
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: progress
                  ? SeedsButton("Importing...")
                  : SeedsButton("Import account", () async {
                      setState(() {
                        progress = true;
                      });

                      String accountName = accountNameController.value.text;
                      String privateKey = privateKeyController.value.text;

                      await saveAccount(accountName, privateKey);

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Welcome(accountName),
                      ));
                    }),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return isDebugMode()
        ? SeedsButton("Scan success - continue to create an account", () async {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => CreateAccount(debugInviteSecret),
            ));
          })
        : SeedsButton("Scan failed - back to choose another method", () async {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Onboarding()),
            );
          });
  }
}

class CreateAccount extends StatefulWidget {
  final String inviteSecret;

  CreateAccount(this.inviteSecret);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

Future<bool> isExistingAccount(String accountName) => Future.sync(() => false);

class _CreateAccountState extends State<CreateAccount> {
  var accountNameController = MaskedTextController(
      text: debugAccount,
      mask: '@@@@@@@@@@@@',
      translator: {'@': new RegExp(r'[a-z1234]')});

  final StreamController<bool> _statusNotifier =
      StreamController<bool>.broadcast();

  final StreamController<String> _messageNotifier =
      StreamController<String>.broadcast();

  bool progress = false;

  FocusNode accountNameFocus = FocusNode();

  Widget buildPreloader() {
    return FullscreenLoader(
        statusStream: _statusNotifier.stream,
        messageStream: _messageNotifier.stream,
        afterSuccessCallback: () {
          String accountName = accountNameController.text;

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Welcome(accountName),
            ),
          );
        },
        afterFailureCallback: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => OnboardingMethodChoice(),
            ),
          );
        });
  }

  Future<dynamic> createAccount(String accountName, String publicKey) async {
    if (await isExistingAccount(accountName) == true) {
      throw "Account with chosen name already exists, please choose another";
    }

    String endpointApi = "https://api.telos.eosindex.io";

    EOS.EOSClient client =
        EOS.EOSClient(endpointApi, 'v1', privateKeys: [applicationPrivateKey]);

    Map data = {
      "account": accountName,
      "publicKey": publicKey,
      "invite_secret": widget.inviteSecret,
    };

    List<EOS.Authorization> auth = [
      EOS.Authorization()
        ..actor = applicationAccount
        ..permission = "application"
    ];

    List<EOS.Action> actions = [
      EOS.Action()
        ..account = 'join.seeds'
        ..name = 'accept'
        ..authorization = auth
        ..data = data
    ];

    EOS.Transaction transaction = EOS.Transaction()..actions = actions;

    return client.pushTransaction(transaction, broadcast: true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        OverlayPopupScreen(
          title: "Create account",
          body: Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
            padding: EdgeInsets.only(bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 2,
                      child: Text(
                        "Account name",
                        style: TextStyle(fontFamily: "sfprotext"),
                      ),
                    ),
                    Spacer(flex: 1),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 4,
                      child: TextField(
                        focusNode: accountNameFocus,
                        textAlign: TextAlign.left,
                        textDirection: TextDirection.ltr,
                        showCursor: true,
                        enableInteractiveSelection: false,
                        autofocus: true,
                        controller: accountNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontFamily: "sfprotext",
                          color: Colors.black,
                          fontSize: 32,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: SeedsButton(
                    "Create account",
                    () async {
                      setState(() {
                        progress = true;
                      });

                      accountNameFocus.unfocus();

                      String accountName = accountNameController.text;

                      EOSPrivateKey privateKey = EOSPrivateKey.fromRandom();
                      EOSPublicKey publicKey = privateKey.toEOSPublicKey();

                      try {
                        var response = await createAccount(
                            accountName, publicKey.toString());

                        if (response == null ||
                            response["transaction_id"] == null)
                          throw "Unexpected error, please try again";

                        String trxid = response["transaction_id"];

                        await Future.delayed(Duration.zero);
                        _statusNotifier.add(true);
                        _messageNotifier.add("Transaction hash: $trxid");
                      } catch (err) {
                        print(err);

                        await Future.delayed(Duration.zero);
                        _statusNotifier.add(false);
                        _messageNotifier.add(err.toString());
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                RichText(
                  text: TextSpan(
                      style: TextStyle(
                        color: Colors.black45,
                        fontFamily: "worksans",
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: "Your account name should have "),
                        TextSpan(
                          text: "exactly 12",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                            text:
                                " symbols (lowercase letters and digits only 1-5)"),
                      ]),
                ),
              ],
            ),
          ),
        ),
        progress ? buildPreloader() : Container(),
      ],
    );
  }
}

class OnboardingMethodChoice extends StatefulWidget {
  @override
  _OnboardingMethodChoiceState createState() => _OnboardingMethodChoiceState();
}

class _OnboardingMethodChoiceState extends State<OnboardingMethodChoice> {
  @override
  void initState() {
    super.initState();

    this.processInviteLink();
  }

  void processInviteLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    final Uri deepLink = data?.link;

    handleDeepLink(deepLink);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      handleDeepLink(deepLink);
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });
  }

  void handleDeepLink(deepLink) {
    if (deepLink != null) {
      Map<String, String> queryParams = Uri.splitQueryString(deepLink.toString());

      if (queryParams["inviterAccount"] != null && queryParams["inviteSecret"] != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ShowInvite(queryParams["inviterAccount"], queryParams["inviteSecret"])
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPopupScreen(
      title: "Import account / Scan Invite",
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
        padding: EdgeInsets.only(bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Do you have account?",
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ImportAccount(),
                    ),
                  );
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
              child: SeedsButton("Claim invite code", () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ClaimCode(),
                  ),
                );
              }),
            ),
            // SizedBox(
            //   height: 40,
            //   width: MediaQuery.of(context).size.width,
            //   child: SeedsButton(
            //     "Scan QR Code",
            //     () {
            //       Navigator.of(context).pushReplacement(
            //         MaterialPageRoute(
            //           builder: (context) => ScanCode(),
            //         ),
            //       );
            //     },
            //   ),
            // ),
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

class Welcome extends StatelessWidget {
  final String accountName;

  Welcome(this.accountName);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => IntroViewsFlutter(
        [
          page(
            bubble: Icons.done,
            mainImage: 'assets/images/onboarding4.png',
            body: 'Your wallet almost ready - choose passcode to finish setup',
            title: 'Welcome, $accountName',
          ),
        ],
        key: new UniqueKey(),
        onTapDoneButton: () async {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => App(accountName),
            ),
          );
        },
        doneButtonPersist: true,
        doneText: Text(
          "FINISH",
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
    );
  }
}

class ShowInvite extends StatelessWidget {
  final String inviterAccountName;
  final String inviteSecret;

  ShowInvite(this.inviterAccountName, this.inviteSecret);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => IntroViewsFlutter(
        [
          page(
            bubble: Icons.done,
            mainImage: 'assets/images/onboarding5.png',
            body: 'Accept your invite to create a new account and join SEEDS',
            title: 'You are invited by $inviterAccountName',
          ),
        ],
        key: new UniqueKey(),
        onTapDoneButton: () async {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CreateAccount(inviteSecret),
            ),
          );
        },
        doneButtonPersist: true,
        doneText: Text(
          "ACCEPT",
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
    );
  }
}

class Onboarding extends StatelessWidget {
  final List<PageViewModel> featurePages = [
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

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => SafeArea(
              child: IntroViewsFlutter(
          featurePages,
          key: new UniqueKey(),
          onTapDoneButton: () async {
            if (isDebugMode() && debugInviteSecret != "") {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => CreateAccount(debugInviteSecret),
                ),
              );

              return;
            }

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => OnboardingMethodChoice(),
              ),
            );
          },
          doneButtonPersist: true,
          doneText: Text(
            "JOIN NOW",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "worksans",
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          showSkipButton: false,
          showNextButton: true,
          showBackButton: true,
          pageButtonTextStyles: TextStyle(
            fontFamily: "worksans",
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
