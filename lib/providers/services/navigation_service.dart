import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/app/ecosystem/dho/dho.dart';
import 'package:seeds/screens/app/ecosystem/guardians/guardians.dart';
import 'package:seeds/screens/app/ecosystem/harvest/plant_seeds.dart';
import 'package:seeds/screens/app/ecosystem/invites/create_invite.dart';
import 'package:seeds/screens/app/ecosystem/invites/invites.dart';
import 'package:seeds/screens/app/ecosystem/overview.dart';
import 'package:seeds/screens/app/ecosystem/proposals/proposal_details.dart';
import 'package:seeds/screens/app/ecosystem/proposals/proposals.dart';
import 'package:seeds/screens/app/guardians/guardian_invite.dart';
import 'package:seeds/screens/app/guardians/guardian_invite_sent.dart';
import 'package:seeds/screens/app/guardians/guardians_tabs.dart';
import 'package:seeds/screens/app/guardians/select_guardians.dart';
import 'package:seeds/screens/app/profile/image_viewer.dart';
import 'package:seeds/screens/app/profile/logout.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';
import 'package:seeds/screens/app/wallet/dashboard.dart';
import 'package:seeds/screens/app/wallet/invoice_confirmation.dart';
import 'package:seeds/screens/app/wallet/receive_confirmation.dart';
import 'package:seeds/screens/app/wallet/receive.dart';
import 'package:seeds/screens/app/wallet/receive_custom.dart';
import 'package:seeds/screens/app/wallet/receive_qr.dart';
import 'package:seeds/screens/app/wallet/scan.dart';
import 'package:seeds/screens/app/wallet/transfer/transfer.dart';
import 'package:seeds/screens/app/wallet/transfer/transfer_form.dart';
import 'package:seeds/screens/onboarding/join_process.dart';
import 'package:seeds/screens/onboarding/onboarding.dart';
import 'package:seeds/widgets/page_not_found.dart';

class Routes {
  static final app = "App";
  static final transferForm = "TransferForm";
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
  static final plantSeeds = "plantSeeds";
  static final customTransaction = "CustomTransation";
  static final scanQRCode = "ScanQRCode";
  static final receive = 'Receive';
  static final receiveConfirmation = 'ReceiveConfirmation';
  static final invoiceConfirmation = 'InvoiceConfirmation';
  static final receiveCustom = 'ReceiveCustom';
  static final receiveQR = 'ReceiveQR';
  static final selectGuardians = "SelectGuardians";
  static final inviteGuardians = "InviteGuardians";
  static final inviteGuardiansSent = "InviteGuardiansSent";
  static final guardianTabs = "GuardianTabs";
  static final dho = "DHO";
  static final guardians = "Guardians";
}

class NavigationService {
  final GlobalKey<NavigatorState> onboardingNavigatorKey =
      new GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> appNavigatorKey =
      new GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> walletNavigatorKey =
      new GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> ecosystemNavigatorKey =
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
    Routes.transfer: (_) => Transfer(),
    Routes.invites: (_) => Invites(),
    Routes.createInvite: (_) => CreateInvite(),
    Routes.proposals: (_) => Proposals(),
    Routes.proposalDetailsPage: (args) => ProposalDetailsPage(proposal: args),
    Routes.logout: (_) => Logout(),
    Routes.imageViewer: (args) => ImageViewer(
          arguments: args,
        ),
    Routes.plantSeeds: (_) => PlantSeeds(),
    Routes.customTransaction: (args) => CustomTransaction(args),
    Routes.scanQRCode: (_) => Scan(false),
    Routes.receive: (_) => Receive(),
    Routes.receiveConfirmation: (args) => ReceiveConfirmation(cart: args),
    Routes.receiveCustom: (_) => ReceiveCustom(),
    Routes.receiveQR: (args) => ReceiveQR(amount: args),
    Routes.invoiceConfirmation: (args) => InvoiceConfirmation(invoice: args),
    Routes.selectGuardians: (_) => SelectGuardians(),
    Routes.inviteGuardians: (args) => InviteGuardians(args),
    Routes.inviteGuardiansSent: (_) => InviteGuardiansSent(),
    Routes.guardianTabs: (_) => GuardianTabs(),
    Routes.dho: (_) => DHO(),
    Routes.guardians: (_) => Guardians(),
  };

  final ecosystemRoutes = {
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
    } else if (ecosystemRoutes[routeName] != null) {
      navigatorKey = ecosystemNavigatorKey;
    } else if (onboardingRoutes[routeName] != null) {
      navigatorKey = onboardingNavigatorKey;
    }

    if (navigatorKey.currentState == null) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    if (replace) {
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
        settings: settings,
        builder: (context) => appRoutes[routeName](arguments),
      );
    } else if (onboardingRoutes[routeName] != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => onboardingRoutes[routeName](arguments),
      );
    } else if (ecosystemRoutes[routeName] != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => ecosystemRoutes[routeName](arguments),
      );
    } else if (walletRoutes[routeName] != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => walletRoutes[routeName](arguments),
      );
    } else {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => PageNotFound(
          routeName: settings.name,
          args: settings.arguments,
        ),
      );
    }
  }

  static RoutePredicate predicateForName(String name) {
    return (Route<dynamic> route) {
      //print("Route: ${route.settings.name}" + " modal: ${route is ModalRoute} handlepop: ${route.willHandlePopInternally}");
      if (route.settings.name == "/" && name != "/") {
        print("pop error: Route name not found: "+name);
      }
      return 
        !route.willHandlePopInternally 
        && route is ModalRoute
        && route.settings.name == name || route.settings.name == "/";
    };
  }

}
