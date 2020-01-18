import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/app/explorer/friends.dart';
import 'package:seeds/screens/app/explorer/overview.dart';
import 'package:seeds/screens/app/explorer/proposals/proposal_details.dart';
import 'package:seeds/screens/app/explorer/proposals/proposals.dart';
import 'package:seeds/screens/app/wallet/dashboard.dart';
import 'package:seeds/screens/app/wallet/transfer.dart';
import 'package:seeds/screens/app/wallet/transfer_amount.dart';
import 'package:seeds/screens/app/wallet/transfer_form.dart';
import 'package:seeds/screens/onboarding/claim_code.dart';
import 'package:seeds/screens/onboarding/create_account.dart';
import 'package:seeds/screens/onboarding/import_account.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/screens/onboarding/onboarding_method_choice.dart';
import 'package:seeds/screens/onboarding/show_invite.dart';
import 'package:provider/provider.dart';
import 'package:seeds/screens/onboarding/welcome.dart';
import 'package:seeds/widgets/page_not_found.dart';

class NavigationService {
  final GlobalKey<NavigatorState> onboardingNavigatorKey =
      new GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> appNavigatorKey =
      new GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> walletNavigatorKey =
      new GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> explorerNavigatorKey =
      new GlobalKey<NavigatorState>();

  static NavigationService of(BuildContext context, {bool listen = false}) =>
      Provider.of<NavigationService>(context, listen: listen);

  StreamController<String> streamRouteListener;

  final onboardingRoutes = {
    "Onboarding": (_) => Onboarding(),
    "OnboardingMethodChoice": (_) => OnboardingMethodChoice(),
    "ImportAccount": (_) => ImportAccount(),
    "CreateAccount": (args) => CreateAccount(args),
    "ShowInvite": (args) => ShowInvite(args),
    "ClaimCode": (_) => ClaimCode(),
    "Welcome": (args) => Welcome(args),
  };

  final appRoutes = {
    "App": (_) => App(),
    "TransferForm": (args) => TransferForm(args),
    "TransferAmount": (args) => TransferAmount(args),
  };

  final explorerRoutes = {
    "Overview": (_) => Overview(),
    "Invites": (_) => Friends(),
    "Proposals": (_) => Proposals(),
    "ProposalDetailsPage": (args) => ProposalDetailsPage(proposal: args),
  };

  final walletRoutes = {
    "Dashboard": (_) => Dashboard(),
    "Transfer": (_) => Transfer(),
  };

  void addListener(StreamController<String> listener) {
    streamRouteListener = listener;
  }

  Future<dynamic> navigateTo(String routeName,
      [Object arguments, bool replace = false]) async {
    var navigatorKey;

    if (streamRouteListener != null) {
      streamRouteListener.add(routeName);
    }

    if (appRoutes[routeName] != null) {
      navigatorKey = appNavigatorKey;
    } else if (walletRoutes[routeName] != null) {
      navigatorKey = walletNavigatorKey;
    } else if (explorerRoutes[routeName] != null) {
      navigatorKey = explorerNavigatorKey;
    } else if (onboardingRoutes[routeName] != null) {
      navigatorKey = onboardingNavigatorKey;
    }

    if (navigatorKey.currentState == null) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    if (replace == true) {
      return navigatorKey.currentState
          .pushReplacementNamed(routeName, arguments: arguments);
    } else {
      return navigatorKey.currentState
          .pushNamed(routeName, arguments: arguments);
    }
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    String routeName = settings.name;
    Object arguments = settings.arguments;

    if (appRoutes[routeName] != null) {
      return MaterialPageRoute(
        builder: (context) => appRoutes[routeName](arguments),
      );
    } else if (onboardingRoutes[routeName] != null) {
      return MaterialPageRoute(
        builder: (context) => onboardingRoutes[routeName](arguments),
      );
    } else if (explorerRoutes[routeName] != null) {
      return MaterialPageRoute(
        builder: (_) => explorerRoutes[routeName](arguments),
      );
    } else if (walletRoutes[routeName] != null) {
      return MaterialPageRoute(
        builder: (_) => walletRoutes[routeName](arguments),
      );
    } else {
      return MaterialPageRoute(
        builder: (context) => PageNotFound(
          routeName: settings.name,
          args: settings.arguments,
        ),
      );
    }
  }
}
