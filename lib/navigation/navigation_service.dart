import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/screens/authentication/import_key/import_key_screen.dart';
import 'package:seeds/screens/authentication/login_screen.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/recover_account_found_screen.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/recover_account_screen.dart';
import 'package:seeds/screens/authentication/verification/verification_screen.dart';
import 'package:seeds/screens/explore_screens/explore/explore_screen.dart';
import 'package:seeds/screens/explore_screens/invite/invite_screen.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/plant_seeds_screen.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/unplant_seeds_screen.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/proposal_details_screen.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/vote_screen.dart';
import 'package:seeds/screens/profile_screens/citizenship/citizenship_screen.dart';
import 'package:seeds/screens/profile_screens/contribution/contribution_screen.dart';
import 'package:seeds/screens/profile_screens/edit_name/edit_name_screen.dart';
import 'package:seeds/screens/profile_screens/guardians/guardians_tabs/guardians_screen.dart';
import 'package:seeds/screens/profile_screens/guardians/invite_guardians/invite_guardian_screen.dart';
import 'package:seeds/screens/profile_screens/guardians/invite_guardians_sent/invite_guardians_sent_screen.dart';
import 'package:seeds/screens/profile_screens/guardians/select_guardian/select_guardians_screen.dart';
import 'package:seeds/screens/profile_screens/profile/profile_screen.dart';
import 'package:seeds/screens/profile_screens/recovery_phrase/recovery_phrase_screen.dart';
import 'package:seeds/screens/profile_screens/security/security_screen.dart';
import 'package:seeds/screens/profile_screens/set_currency/set_currency_screen.dart';
import 'package:seeds/screens/profile_screens/support/support_screen.dart';
import 'package:seeds/screens/authentication/sign_up/signup_screen.dart';
import 'package:seeds/screens/transfer/receive/receive_detail_qr_code/receive_detail_qr_code.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/receive_seeds_screen.dart';
import 'package:seeds/screens/transfer/receive/receive_selection/receive_screen.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/send_confirmation_screen.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/send_enter_data_screen.dart';
import 'package:seeds/screens/transfer/send/send_scanner/send_scanner_screen.dart';
import 'package:seeds/screens/transfer/send/send_search_user/send_search_user_screen.dart';
import 'package:seeds/screens/wallet/wallet_screen.dart';
import 'package:seeds/screens/page_not_found_screen.dart';

class Routes {
  static final onboarding = 'Onboarding';
  static final createAccount = 'CreateAccount';
  static final showInvite = 'ShowInvite';
  static final claimCode = 'ClaimCode';
  static final welcome = 'Welcome';
  static final transfer = 'Transfer';
  static final sendEnterData = 'SendEnterData';
  static final createInvite = 'CreateInvite';
  static final vote = 'vote';
  static final proposalDetails = 'ProposalDetails';
  static final overview = 'Overview';
  static final explore = 'Explore';
  static final wallet = 'Wallet';
  static final plantSeeds = 'plantSeeds';
  static final unPlantSeeds = 'unPlantSeeds';
  static final sendConfirmationScreen = 'SendConfirmationScreen';
  static final scanQRCode = 'ScanQRCode';
  static final receiveScreen = "receiveScreen";
  static final receiveEnterDataScreen = "receiveEnterDataScreen";
  static final receiveQR = 'ReceiveQR';
  static final selectGuardians = 'SelectGuardians';
  static final inviteGuardians = 'InviteGuardians';
  static final inviteGuardiansSent = 'InviteGuardiansSent';
  static final guardianTabs = 'GuardianTabs';
  static final support = 'Support';
  static final security = 'Security';
  static final editName = 'EditName';
  static final setCurrency = "SetCurrency";
  static final citizenship = 'CitizenShip';
  static final contribution = 'Contribution';
  static final login = "Login";
  static final importKey = "ImportKey";
  static final verification = "verification";
  static final signup = 'signUp';
  static final recoverAccount = 'recoverAccount';
  static final recoverAccountFound = 'recoverAccountFound';
  static final profile = 'profile';
  static final recoveryPhrase = 'recoveryPhrase';
}

class NavigationService {
  final GlobalKey<NavigatorState> onboardingNavigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> walletNavigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> ecosystemNavigatorKey = GlobalKey<NavigatorState>();

  static NavigationService of(BuildContext context, {bool listen = false}) =>
      Provider.of<NavigationService>(context, listen: listen);

  StreamController<String>? streamRouteListener;

  final onboardingRoutes = {
    Routes.login: (_) => const LoginScreen(),
    Routes.importKey: (_) => const ImportKeyScreen(),
    Routes.recoverAccount: (_) => const RecoverAccountScreen(),
    Routes.recoverAccountFound: (_) => const RecoverAccountFoundScreen(),
    Routes.signup: (_) => const SignupScreen(null),
  };

  final appRoutes = {
    Routes.profile: (_) => const ProfileScreen(),
    Routes.transfer: (_) => const SendSearchUserScreen(),
    Routes.sendEnterData: (_) => const SendEnterDataScreen(),
    Routes.createInvite: (_) => const InviteScreen(),
    Routes.vote: (_) => const VoteScreen(),
    Routes.proposalDetails: (_) => const ProposalDetailsScreen(),
    Routes.plantSeeds: (_) => const PlantSeedsScreen(),
    Routes.unPlantSeeds: (_) => const UnplantSeedsScreen(),
    Routes.sendConfirmationScreen: (args) => const SendConfirmationScreen(),
    Routes.scanQRCode: (_) => const SendScannerScreen(),
    Routes.receiveScreen: (_) => const ReceiveScreen(),
    Routes.receiveEnterDataScreen: (_) => const ReceiveEnterDataScreen(),
    Routes.receiveQR: (args) => ReceiveDetailQrCodeScreen(args),
    Routes.selectGuardians: (_) => const SelectGuardiansScreen(),
    Routes.inviteGuardians: (args) => const InviteGuardians(),
    Routes.inviteGuardiansSent: (_) => const InviteGuardiansSentScreen(),
    Routes.guardianTabs: (_) => const GuardiansScreen(),
    Routes.support: (_) => const SupportScreen(),
    Routes.security: (_) => const SecurityScreen(),
    Routes.editName: (_) => const EditNameScreen(),
    Routes.setCurrency: (_) => const SetCurrencyScreen(),
    Routes.citizenship: (_) => const CitizenshipScreen(),
    Routes.contribution: (_) => const ContributionScreen(),
    Routes.verification: (_) => const VerificationScreen(),
    Routes.recoveryPhrase: (_) => const RecoveryPhraseScreen(),
  };

  // iOS: full screen routes pop up from the bottom and disappear vertically too
  // On iOS that's a standard full screen dialog
  // Has no effect on Android.
  final fullScreenRoutes = {
    Routes.verification,
  };

  final ecosystemRoutes = {
    Routes.explore: (_) => const ExploreScreen(),
  };

  final walletRoutes = {
    Routes.wallet: (_) => const WalletScreen(),
  };

  void addListener(StreamController<String> listener) {
    streamRouteListener = listener;
  }

  Future<dynamic> navigateTo(String routeName, [Object? arguments, bool replace = false]) async {
    late GlobalKey<NavigatorState> navigatorKey;

    if (streamRouteListener != null) {
      streamRouteListener!.add(routeName);
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
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (replace) {
      return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
    } else {
      return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
    }
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name;
    final arguments = settings.arguments;

    if (appRoutes[routeName!] != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => appRoutes[routeName]!(arguments),
        fullscreenDialog: fullScreenRoutes.contains(routeName),
      );
    } else if (onboardingRoutes[routeName] != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => onboardingRoutes[routeName]!(arguments),
      );
    } else if (ecosystemRoutes[routeName] != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => ecosystemRoutes[routeName]!(arguments),
      );
    } else if (walletRoutes[routeName] != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => walletRoutes[routeName]!(arguments),
      );
    } else {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => PageNotFoundScreen(routeName: settings.name!, args: settings.arguments),
      );
    }
  }

  static RoutePredicate predicateForName(String name) {
    return (Route<dynamic> route) {
      //print("Route: ${route.settings.name}" + " modal: ${route is ModalRoute} handlepop: ${route.willHandlePopInternally}");
      if (route.settings.name == '/' && name != '/') {
        print('pop error: Route name not found: $name');
      }
      return !route.willHandlePopInternally && route is ModalRoute && route.settings.name == name ||
          route.settings.name == '/';
    };
  }
}
