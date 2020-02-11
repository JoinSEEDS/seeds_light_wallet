import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/app/explorer/exchange/buy_seeds.dart';
import 'package:seeds/screens/app/explorer/invites/create_invite.dart';
import 'package:seeds/screens/app/explorer/invites/invites.dart';
import 'package:seeds/screens/app/explorer/overview.dart';
import 'package:seeds/screens/app/explorer/proposals/proposal_details.dart';
import 'package:seeds/screens/app/explorer/proposals/proposals.dart';
import 'package:seeds/screens/app/profile/image_viewer.dart';
import 'package:seeds/screens/app/profile/logout.dart';
import 'package:seeds/screens/app/wallet/dashboard.dart';
import 'package:seeds/screens/app/wallet/transfer.dart';
import 'package:seeds/screens/app/wallet/transfer_amount.dart';
import 'package:seeds/screens/app/wallet/transfer_form.dart';
import 'package:seeds/screens/onboarding/join_process.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/widgets/page_not_found.dart';

class Routes {
  static final app = "App";
  static final transferForm = "TransferForm";
  static final transferAmount = "TransferAmount";
  static final onboarding = "Onboarding";
  static final joinProcess = "JoinProcess";
  static final importAccount = "ImportAccount";
  static final createAccount = "CreateAccount";
  static final showInvite = "ShowInvite";
  static final claimCode = "ClaimCode";
  static final welcome = "Welcome";
  static final transfer = "Transfer";
  static final invites = "Invites";
  static final createInvite = "CreateInvite";
  static final proposals = "Proposals";
  static final proposalDetailsPage = "ProposalDetailsPage";
  static final overview = "Overview";
  static final dashboard = "Dashboard";
  static final logout = "Logout";
  static final imageViewer = 'ImageViewer';
  static final buySeeds = "BuySeeds";
}

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
    Routes.onboarding: (_) => Onboarding(),
    Routes.joinProcess: (_) => JoinProcess(),
    // Routes.importAccount: (_) => ImportAccount(),
    // Routes.createAccount: (args) => CreateAccount(args),
    // Routes.showInvite: (args) => ShowInvite(args),
    // Routes.claimCode: (_) => ClaimCode(),
    // Routes.welcome: (args) => Welcome(args),
  };

  final appRoutes = {
    Routes.app: (_) => App(),
    Routes.transferForm: (args) => TransferForm(args),
    Routes.transferAmount: (args) => TransferAmount(args),
    Routes.transfer: (_) => Transfer(),
    Routes.invites: (_) => Invites(),
    Routes.createInvite: (_) => CreateInvite(),
    Routes.proposals: (_) => Proposals(),
    Routes.proposalDetailsPage: (args) => ProposalDetailsPage(proposal: args),
    Routes.logout: (_) => Logout(),
    Routes.imageViewer: (args) => ImageViewer(
          arguments: args,
        ),
    Routes.buySeeds: (_) => BuySeeds(),
  };

  final explorerRoutes = {
    Routes.overview: (_) => Overview(),
  };

  final walletRoutes = {
    Routes.dashboard: (_) => Dashboard(),
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
