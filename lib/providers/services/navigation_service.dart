import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teloswallet/screens/app/app.dart';
import 'package:teloswallet/screens/app/tools/change_endpoint.dart';
import 'package:teloswallet/screens/app/tools/logout.dart';
import 'package:teloswallet/screens/app/tools/manage_accounts.dart';
import 'package:teloswallet/screens/app/tools/manage_resources.dart';
import 'package:teloswallet/screens/app/scan/custom_transaction.dart';
import 'package:teloswallet/screens/app/wallet/transfer_form.dart';
import 'package:teloswallet/widgets/page_not_found.dart';

class Routes {
  static final app = "App";
  static final transferForm = "TransferForm";
  static final transfer = "Transfer";
  static final manageResources = "ManageResources";
  static final manageAccounts = "ManageAccounts";
  static final changeEndpoint = "ChangeEndpoint";
  static final customTransaction = "CustomTransaction";
  static final logout = "Logout";
}

class NavigationService {
  final GlobalKey<NavigatorState> onboardingNavigatorKey =
      new GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> appNavigatorKey =
      new GlobalKey<NavigatorState>();

  static NavigationService of(BuildContext context, {bool listen = false}) =>
      Provider.of<NavigationService>(context, listen: listen);

  StreamController<String> streamRouteListener;

  final appRoutes = {
    Routes.app: (_) => App(),
    Routes.transferForm: (_) => TransferForm(),
    Routes.changeEndpoint: (_) => ChangeEndpoint(),
    Routes.manageAccounts: (_) => ManageAccounts(),
    Routes.manageResources: (_) => ManageResources(),
    Routes.customTransaction: (args) => CustomTransaction(args),
    Routes.logout: (_) => Logout(),
  };

  void addListener(StreamController<String> listener) {
    streamRouteListener = listener;
  }

  Future<dynamic> navigateTo(String routeName,
      [Object arguments, bool replace = false]) async {
    if (streamRouteListener != null) {
      streamRouteListener.add(routeName);
    }

    if (appNavigatorKey.currentState == null) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    if (replace == true) {
      return appNavigatorKey.currentState
          .pushReplacementNamed(routeName, arguments: arguments);
    } else {
      return appNavigatorKey.currentState
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
