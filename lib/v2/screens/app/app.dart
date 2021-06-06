import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/notifiers/connection_notifier.dart';
import 'package:seeds/screens/app/ecosystem/ecosystem.dart';
import 'package:seeds/screens/app/wallet/wallet.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/notification_badge.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/i18n/app/app.i18.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/profile_screens/profile/profile_screen.dart';

class App extends StatefulWidget {
  const App();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final List<AppScreenItem> _appScreenItems = [
    AppScreenItem(
      title: "Wallet".i18n,
      icon: 'assets/images/navigation_bar/wallet.svg',
      iconSelected: 'assets/images/navigation_bar/wallet_selected.svg',
      screen: Wallet(),
      index: 0,
    ),
    AppScreenItem(
      title: "Explore".i18n,
      icon: 'assets/images/navigation_bar/explore.svg',
      iconSelected: 'assets/images/navigation_bar/explore_selected.svg',
      screen: Ecosystem(),
      index: 1,
    ),
    AppScreenItem(
      title: "Profile".i18n,
      icon: 'assets/images/navigation_bar/user_profile.svg',
      iconSelected: 'assets/images/navigation_bar/user_profile_selected.svg',
      screen: ProfileScreen(),
      index: 2,
    ),
  ];
  final PageController _pageController = PageController(initialPage: 0, keepPage: true);
  late GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        // Enable the flag that indicates is in OnResumeAuth
        BlocProvider.of<AuthenticationBloc>(context).add(const InitOnResumeAuth());
        // Navigate to verification screen (verify mode) on app resume
        Navigator.of(_navigatorKey.currentContext!).pushNamedIfNotCurrent(Routes.verification);
        break;
      case AppLifecycleState.resumed:
        Provider.of<ConnectionNotifier>(context, listen: false).discoverEndpoints();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _navigatorKey = NavigationService.of(context).appNavigatorKey;
    return BlocProvider(
      create: (context) => AppBloc(),
      child: BlocListener<AppBloc, AppState>(
        listenWhen: (previous, current) => previous.index != current.index,
        listener: (_, state) => _pageController.jumpToPage(state.index),
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _appScreenItems.map((i) => i.screen).toList(),
          ),
          bottomNavigationBar: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              if (state.showGuardianRecoveryAlert) {
                showAccountUnderRecoveryDialog(context);
              }
              return Container(
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.white, width: 0.2))),
                child: BottomNavigationBar(
                  currentIndex: state.index,
                  onTap: (index) => BlocProvider.of<AppBloc>(context).add(BottomBarTapped(index: index)),
                  selectedLabelStyle: Theme.of(context).textTheme.subtitle3,
                  unselectedLabelStyle: Theme.of(context).textTheme.subtitle3,
                  selectedItemColor: AppColors.white,
                  items: [
                    for (var i in _appScreenItems)
                      BottomNavigationBarItem(
                        activeIcon:
                            Padding(padding: const EdgeInsets.only(bottom: 4), child: SvgPicture.asset(i.iconSelected)),
                        icon: Stack(
                          children: [
                            SvgPicture.asset(i.icon),
                            if (state.hasNotification && i.index == 2)
                              const Positioned(right: 3, top: 3, child: NotificationBadge())
                          ],
                        ),
                        label: state.index == i.index ? i.title : '',
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

extension NavigatorStateExtension on NavigatorState {
  /// Navigate only if the new route is not the same as the current one
  void pushNamedIfNotCurrent(String routeName, {Object? arguments}) {
    if (!isCurrent(routeName)) {
      pushNamed(routeName, arguments: arguments);
    }
  }

  bool isCurrent(String routeName) {
    bool isCurrent = false;
    popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}

Future<void> showAccountUnderRecoveryDialog(BuildContext buildContext) async {
  // var service = EosService.of(buildContext, listen: false);
  // var accountName = SettingsNotifier.of(buildContext, listen: false).accountName;

  return showDialog<void>(
    context: buildContext,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                FadeInImage.assetNetwork(
                    placeholder: "assets/images/guardians/guardian_shield.png",
                    image: "assets/images/guardians/guardian_shield.png"),
                const Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 8),
                  child: Text(
                    "Recovery Mode Initiated",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Someone has initiated the '),
                        TextSpan(text: 'Recovery ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                'process for your account. If you did not request to recover your account please select cancel recovery.  '),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButtonLong(
              title: "Cancel Recovery",
              onPressed: () async {
                // await GuardianServices()
                //     .stopActiveRecovery(service, accountName)
                //     .then((value) => Navigator.pop(context))
                //     .catchError((onError) => onStopRecoveryError(onError));
              },
            ),
          ],
        );
      });
    },
  );
}
