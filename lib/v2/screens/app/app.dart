import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/components/notification_badge.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/i18n/widgets.i18n.dart';
import 'package:seeds/providers/notifiers/connection_notifier.dart';
import 'package:seeds/screens/app/ecosystem/ecosystem.dart';
import 'package:seeds/v2/main.dart' show SeedsMaterialApp;
import 'package:seeds/v2/screens/profile_screens/profile/profile_screen.dart';
import 'package:seeds/screens/app/wallet/wallet.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/bloc.dart';
import 'package:seeds/providers/services/navigation_service.dart';

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
        // Initialize auth when app resume
        BlocProvider.of<AuthenticationBloc>(context).add(const InitResumeAuth());
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
    var navigationService = NavigationService.of(context);
    return SeedsMaterialApp(
      navigatorKey: navigationService.appNavigatorKey,
      onGenerateRoute: navigationService.onGenerateRoute,
      home: BlocProvider(
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
                return Container(
                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.white, width: 0.2))),
                  child: BottomNavigationBar(
                    currentIndex: state.index,
                    onTap: (index) => BlocProvider.of<AppBloc>(context).add(BottomBarTapped(index: index)),
                    selectedLabelStyle: Theme.of(context).textTheme.caption,
                    unselectedLabelStyle: Theme.of(context).textTheme.caption,
                    items: [
                      for (var i in _appScreenItems)
                        BottomNavigationBarItem(
                          activeIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 4), child: SvgPicture.asset(i.iconSelected)),
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
      ),
    );
  }
}
