import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/notifiers/connection_notifier.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';
import 'package:seeds/screens/app/ecosystem/ecosystem.dart';
import 'package:seeds/screens/app/wallet/wallet.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/notification_badge.dart';
import 'package:seeds/v2/components/snack_bar_info.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/i18n/app/app.i18.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/app/components/account_under_recovery_screen.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_page_commands.dart';
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
  late AppBloc _appBloc;
  late GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    _appBloc = AppBloc()..add(HandleInitialDeepLink());
    BlocProvider.of<RatesBloc>(context).add(const OnFetchRates());
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
        BlocProvider.of<RatesBloc>(context).add(const OnFetchRates());
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
      create: (_) => _appBloc,
      child: Scaffold(
        body: BlocConsumer<AppBloc, AppState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (context, state) {
            var pageCommand = state.pageCommand;
            _appBloc.add(ClearAppPageCommand());
            if (pageCommand is BottomBarNavigateToIndex) {
              _pageController.jumpToPage(pageCommand.index);
            } else if (pageCommand is ShowStopGuardianRecoveryFailed) {
              SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
            } else if (pageCommand is ShowStopGuardianRecoverySuccess) {
              SnackBarInfo(pageCommand.message, ScaffoldMessenger.of(context)).show();
            } else if (pageCommand is ProcessSigningRequest) {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  fullscreenDialog: true,
                  transitionsBuilder: (_, animation, __, child) {
                    var tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
                    var curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.bounceInOut);
                    // child is the value returned by pageBuilder
                    return SlideTransition(position: tween.animate(curvedAnimation), child: child);
                  },
                  pageBuilder: (context, _, __) {
                    return CustomTransaction(
                      CustomTransactionArguments(
                        account: pageCommand.action.account,
                        name: pageCommand.action.name,
                        data: Map<String, dynamic>.from(pageCommand.action.data as Map<dynamic, dynamic>),
                      ),
                    );
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.pageState == PageState.loading) {
              return const FullPageLoadingIndicator();
            } else {
              if (state.showGuardianRecoveryAlert) {
                return const AccountUnderRecoveryScreen();
              } else {
                return PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _appScreenItems.map((i) => i.screen).toList(),
                );
              }
            }
          },
        ),
        bottomNavigationBar: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.white, width: 0.2))),
              child: BottomNavigationBar(
                currentIndex: state.index,
                onTap: (index) => _appBloc.add(BottomBarTapped(index: index)),
                selectedLabelStyle: Theme.of(context).textTheme.subtitle3,
                unselectedLabelStyle: Theme.of(context).textTheme.subtitle3,
                selectedItemColor: AppColors.white,
                items: [
                  for (var i in _appScreenItems)
                    BottomNavigationBarItem(
                      activeIcon:
                          Padding(padding: const EdgeInsets.only(bottom: 4.0), child: SvgPicture.asset(i.iconSelected)),
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Padding(padding: const EdgeInsets.all(4.0), child: SvgPicture.asset(i.icon)),
                          if (state.hasNotification && i.index == 2)
                            const Positioned(top: -2, right: -16, child: NotificationBadge())
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
