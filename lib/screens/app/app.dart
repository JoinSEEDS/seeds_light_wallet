import 'dart:async';
import 'dart:typed_data';

import 'package:dart_esr/dart_esr.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
// import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/features/scanner/telos_signing_manager.dart';
import 'package:seeds/i18n/widgets.i18n.dart';
import 'package:seeds/providers/notifiers/connection_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/services/links_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/ecosystem/ecosystem.dart';
import 'package:seeds/v2/screens/profile/profile_screen.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';
import 'package:seeds/screens/app/wallet/wallet.dart';
import 'package:seeds/widgets/pending_notification.dart';
import 'package:uuid/uuid.dart';
import 'package:eosdart/src/serialize.dart' as ser;

class NavigationTab {
  final String title;
  final String icon;
  final String iconSelected;
  final Function screenBuilder;
  final int index;

  NavigationTab(
      {this.title,
      this.icon,
      this.iconSelected,
      this.screenBuilder,
      this.index});
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
      iconSelected: 'assets/images/navigation_bar/wallet_selected.svg',
      screenBuilder: () => Wallet(),
      index: 0,
    ),
    NavigationTab(
      title: "Explore".i18n,
      icon: 'assets/images/navigation_bar/explore.svg',
      iconSelected: 'assets/images/navigation_bar/explore_selected.svg',
      screenBuilder: () => Ecosystem(),
      index: 1,
    ),
    NavigationTab(
      title: "Profile".i18n,
      icon: 'assets/images/navigation_bar/user_profile.svg',
      iconSelected: 'assets/images/navigation_bar/user_profile_selected.svg',
      screenBuilder: () => ProfileScreen(),
      index: 2,
    ),
  ];

  final StreamController<String> changePageNotifier =
      StreamController<String>.broadcast();

  int index = 0;
  PageController pageController =
      PageController(initialPage: 0, keepPage: true);

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
        Provider.of<ConnectionNotifier>(context, listen: false)
            .discoverEndpoints();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void processSigningRequests() {
    Provider.of<LinksService>(context, listen: false)
        .listenSigningRequests((final link) async {
      if (link == null) {
        return;
      }

      var request = SeedsESR(uri: link);

      // if (SigningRequestUtils.isIdentity(request.actions.first)) {
      if (request.manager.data.req[0] == "identity") {
        if (request.manager.data.req[1] == null ||
            request.manager.data.req[1]["permission"] == null) {
          request.manager.data.req[1]["permission"] = {
            "actor": SettingsNotifier.of(context, listen: false).accountName,
            "permission": "active"
          };
        }

        // var confirmed = true;

        var confirmed = await showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Confirm Authorization"),
                actions: [
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  FlatButton(
                    child: Text("Confirm"),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            });

        if (confirmed == true) {
          // Scaffold.of(context).showSnackBar(
          //   SnackBar(
          //     content: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         CircularProgressIndicator(),
          //         Text("Authorizing..."),
          //       ],
          //     ),
          //   ),
          // );

          try {
            var abis = await request.manager.fetchAbis();

            var signer = Authorization()
              ..actor = SettingsNotifier.of(context, listen: false).accountName
              ..permission = "active";

            // var blocksBehind = 3;
            // var info =
            //     await EosService.of(context, listen: false).client.getInfo();
            // var refBlock = await EosService.of(context, listen: false)
            //     .client
            //     .getBlock((info.headBlockNum - blocksBehind).toString());
            // var ctx = TransactionContext(
            //   timestamp: refBlock.timestamp,
            //   blockNum: refBlock.blockNum,
            //   refBlockPrefix: refBlock.refBlockPrefix,
            // );

            ResolvedSigningRequest resolved =
                request.manager.resolve(abis, signer, null);

            var signBuf = Uint8List.fromList(List.from(ser.stringToHex(chainId))
              ..addAll(resolved.serializedTransaction)
              ..addAll(Uint8List(32)));

            var walletPrivateKey =
                SettingsNotifier.of(context, listen: false).privateKey;

            print(walletPrivateKey);

            var signature = EOSPrivateKey.fromString(walletPrivateKey)
                .sign(signBuf)
                .toString();

            // CallbackPayload payload = CallbackPayload(
            //   sig: "", // resolved.transaction.signatures[0],
            //   // tx: resolved.transaction.id,
            //   rbn: resolved.transaction.refBlockNum.toString(),
            //   rid: resolved.transaction.refBlockPrefix.toString(),
            //   ex: resolved.transaction.expiration.toString(),
            //   req: resolved.request.encode(),
            //   sa: resolved.signer.actor,
            //   sp: resolved.signer.permission,
            //   // cid: info.chainId,
            // );

            // var sessionId = Uuid().v4();
            // var linkCallbackHandler = "https://cb.anchor.link/$sessionId";

            var linkPrivateKey = EOSPrivateKey.fromRandom();
            var linkPublicKey = linkPrivateKey.toEOSPublicKey().toString();

            var transactionId = resolved.getTransactionId().toLowerCase();

            print(resolved.request.encode());
            print(link);

            var body = """{
                "tx": "$transactionId",
                "sig": "$signature", 
                "rbn": "${resolved.transaction.refBlockNum.toString()}",
                "rid": "${resolved.transaction.refBlockPrefix.toString()}",
                "ex": "${resolved.transaction.expiration.toString()}",
                "req": "${resolved.request.encode()}",
                "sa": "${resolved.signer.actor}",
                "sp": "${resolved.signer.permission}",
                "cid": "$chainId"
              }""";

            // opt-in sessions
            // "link_ch": "$linkCallbackHandler",
            // "link_key": "$linkPublicKey",
            // "link_name": "Seeds Wallet"

            print(request.manager.data.callback);
            print(body);

            var result = await post(
              request.manager.data.callback,
              body: body,
            );

            print(result.body);

            // Scaffold.of(context).hideCurrentSnackBar();
          } catch (err) {
            print(err);
            // Scaffold.of(context).hideCurrentSnackBar();

            // Scaffold.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(err.toString()),
            //     duration: Duration(seconds: 3),
            //   ),
            // );
          }
        } else {
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
                  var tween =
                      Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
                  var curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.bounceInOut,
                  );

                  return SlideTransition(
                    position: tween.animate(curvedAnimation),
                    child: child, // child is the value returned by pageBuilder
                  );
                },
                pageBuilder: (BuildContext context, _, __) =>
                    CustomTransaction(CustomTransactionArguments(
                      account: action.account,
                      name: action.name,
                      data: data,
                    ))),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildPageView(),
      bottomNavigationBar: StreamBuilder<bool>(
          stream: FirebaseDatabaseService().hasGuardianNotificationPending(
              SettingsNotifier.of(context, listen: false).accountName),
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
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
              icon: Icon(Icons.qr_code_scanner, size: 28),
              onPressed: () =>
                  NavigationService.of(context).navigateTo(Routes.scanQRCode)),
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

  BottomNavigationBarItem buildIcon(String title, String icon,
      String selectedIcon, bool isSelected, bool profileNotification) {
    return BottomNavigationBarItem(
      activeIcon: SvgPicture.asset(selectedIcon, height: 24, width: 24),
      icon: Stack(overflow: Overflow.visible, children: <Widget>[
        SvgPicture.asset(icon, height: 24, width: 24),
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
      title: isSelected
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(title, style: Theme.of(context).textTheme.caption),
            )
          : SizedBox.shrink(),
    );
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
      backgroundColor: AppColors.primary,
      items: navigationTabs
          .map(
            (tab) => buildIcon(tab.title, tab.icon, tab.iconSelected,
                tab.index == index, showGuardianNotification),
          )
          .toList(),
    );
  }
}
