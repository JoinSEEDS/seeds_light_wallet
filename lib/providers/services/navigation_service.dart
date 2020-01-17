import 'package:flutter/material.dart';
import 'package:seeds/screens/app/explorer/proposals/proposal_details.dart';
import 'package:seeds/screens/app/explorer/proposals/proposal_form.dart';
import 'package:seeds/screens/app/explorer/proposals/proposals.dart';
import 'package:seeds/screens/app/wallet/transfer.dart';
import 'package:seeds/screens/app/wallet/transfer_amount.dart';
import 'package:seeds/screens/app/wallet/transfer_form.dart';
import 'package:seeds/screens/onboarding/claim_code.dart';
import 'package:seeds/screens/onboarding/create_account.dart';
import 'package:seeds/screens/onboarding/import_account.dart';
import 'package:seeds/screens/onboarding/onboarding_method_choice.dart';
import 'package:seeds/screens/onboarding/show_invite.dart';
import 'package:provider/provider.dart';
import 'package:seeds/screens/onboarding/welcome.dart';
import 'package:seeds/widgets/page_not_found.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> transferNavigatorKey =
      new GlobalKey<NavigatorState>();

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<NavigationService>(context, listen: listen);

  Future<dynamic> showTransferAmount(String amountValue) {
    return transferNavigatorKey.currentState.push(
      MaterialPageRoute(
        builder: (context) => TransferAmount(amountValue),
        fullscreenDialog: true,
      ),
    );
  }

  bool closeTransferForm() {
    return transferNavigatorKey.currentState.pop();
  }

  Future<dynamic> navigateTo(String routeName, Object arguments,
      {replace = false}) {

    if (replace == true) {
      return navigatorKey.currentState
          .pushReplacementNamed(routeName, arguments: arguments);
    } else {
      return navigatorKey.currentState
          .pushNamed(routeName, arguments: arguments);
    }
  }

  Future<dynamic> showTransferScreen() {
    return navigatorKey.currentState.pushNamed("Transfer");
  }

  RouteFactory onGenerateRouteFromOnboarding = (settings) {
    if (settings.name == "ShowInvite") {
      final ShowInviteArguments arguments = settings.arguments;

      return MaterialPageRoute(
        builder: (context) => ShowInvite(
          arguments.inviterAccount,
          arguments.inviteSecret,
        ),
      );
    } else if (settings.name == "ImportAccount") {
      return MaterialPageRoute(
        builder: (context) => ImportAccount(),
      );
    } else if (settings.name == "ClaimCode") {
      return MaterialPageRoute(
        builder: (context) => ClaimCode(),
      );
    } else if (settings.name == "Welcome") {
      return MaterialPageRoute(
        builder: (context) => Welcome(settings.arguments),
      );
    } else if (settings.name == "CreateAccount") {
      return MaterialPageRoute(
        builder: (_) => CreateAccount(settings.arguments),
      );      
    } else if (settings.name == "OnboardingMethodChoice") {
      return MaterialPageRoute(
        builder: (_) => OnboardingMethodChoice(),
      );
    }

    return MaterialPageRoute(
        builder: (context) =>
            PageNotFound(routeName: settings.name, args: settings.arguments));
  };

  RouteFactory onGenerateRouteFromApplication = (settings) {
    if (settings.name == "ProposalForm") {
      return MaterialPageRoute(
        builder: (context) => Proposals(),
      );
    } else if (settings.name == "Transfer") {
      return MaterialPageRoute(builder: (_) => Transfer());
    } else if (settings.name == "TransferForm") {
      return MaterialPageRoute(
        builder: (context) => TransferForm(settings.arguments),
      );
    } else if (settings.name == "ProposalDetailsPage") {
      return MaterialPageRoute(
        builder: (_) => ProposalDetailsPage(proposal: settings.arguments),
      );
    }

    return MaterialPageRoute(
        builder: (context) =>
            PageNotFound(routeName: settings.name, args: settings.arguments));
  };
}
