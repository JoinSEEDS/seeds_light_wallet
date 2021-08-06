import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/screens/app/ecosystem/dho/dho.dart';
import 'package:seeds/screens/app/ecosystem/guardians/guardians.dart';
import 'package:seeds/screens/app/ecosystem/invites/invites.dart';
import 'package:seeds/screens/app/profile/image_viewer.dart';
import 'package:seeds/screens/app/profile/logout.dart';
import 'package:seeds/screens/app/wallet/receive.dart';
import 'package:seeds/screens/app/wallet/receive_confirmation.dart';
import 'package:seeds/screens/app/wallet/receive_custom.dart';
import 'package:seeds/screens/app/wallet/transfer/transfer_form.dart';
import 'package:seeds/screens/onboarding/join_process.dart';
import 'package:seeds/v2/screens/authentication/import_key/import_key_screen.dart';
import 'package:seeds/v2/screens/authentication/login_screen.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/recover_account_found_screen.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/recover_account_screen.dart';
import 'package:seeds/v2/screens/authentication/verification/verification_screen.dart';
import 'package:seeds/v2/screens/explore_screens/explore/explore_screen.dart';
import 'package:seeds/v2/screens/explore_screens/invite/invite_screen.dart';
import 'package:seeds/v2/screens/explore_screens/plant_seeds/plant_seeds_screen.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/proposal_details_screen.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/vote_screen.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/citizenship_screen.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/contribution_screen.dart';
import 'package:seeds/v2/screens/profile_screens/edit_name/edit_name_screen.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/guardians_screen.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/invite_guardians/invite_guardian_screen.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/invite_guardians_sent/invite_guardians_sent_screen.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/select_guardian/select_guardians_screen.dart';
import 'package:seeds/v2/screens/profile_screens/profile/profile_screen.dart';
import 'package:seeds/v2/screens/profile_screens/security/security_screen.dart';
import 'package:seeds/v2/screens/profile_screens/set_currency/set_currency_screen.dart';
import 'package:seeds/v2/screens/profile_screens/support/support_screen.dart';
import 'package:seeds/v2/screens/sign_up/signup_screen.dart';
import 'package:seeds/v2/screens/transfer/receive/receive_detail_qr_code/receive_detail_qr_code.dart';
import 'package:seeds/v2/screens/transfer/receive/receive_enter_data/receive_seeds_screen.dart';
import 'package:seeds/v2/screens/transfer/receive/receive_selection/receive_screen.dart';
import 'package:seeds/v2/screens/transfer/send/send_confirmation/send_confirmation_screen.dart';
import 'package:seeds/v2/screens/transfer/send/send_enter_data/send_enter_data_screen.dart';
import 'package:seeds/v2/screens/transfer/send/send_scanner/send_scanner_screen.dart';
import 'package:seeds/v2/screens/transfer/send/send_search_user/send_search_user_screen.dart';
import 'package:seeds/v2/screens/wallet/wallet_screen.dart';
import 'package:seeds/widgets/page_not_found.dart';

class Routes {
  static final transferForm = 'TransferForm';
  static final onboarding = 'Onboarding';
  static final joinProcess = 'JoinProcess';
  static final createAccount = 'CreateAccount';
  static final showInvite = 'ShowInvite';
  static final claimCode = 'ClaimCode';
  static final welcome = 'Welcome';
  static final transfer = 'Transfer';
  static final sendEnterData = 'SendEnterData';
  static final invites = 'Invites';
  static final createInvite = 'CreateInvite';
  static final vote = 'vote';
  static final proposalDetails = 'ProposalDetails';
  static final overview = 'Overview';
  static final explore = 'Explore';
  static final wallet = 'Wallet';
  static final logout = 'Logout';
  static final imageViewer = 'ImageViewer';
  static final plantSeeds = 'plantSeeds';
  static final sendConfirmationScreen = 'SendConfirmationScreen';
  static final scanQRCode = 'ScanQRCode';
  static final receiveScreen = "receiveScreen";
  static final receiveEnterDataScreen = "receiveEnterDataScreen";
  static final receive = 'Receive';
  static final receiveConfirmation = 'ReceiveConfirmation';
  static final receiveCustom = 'ReceiveCustom';
  static final receiveQR = 'ReceiveQR';
  static final selectGuardians = 'SelectGuardians';
  static final inviteGuardians = 'InviteGuardians';
  static final inviteGuardiansSent = 'InviteGuardiansSent';
  static final guardianTabs = 'GuardianTabs';
  static final dho = 'DHO';
  static final guardians = 'Guardians';
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
    Routes.joinProcess: (_) => JoinProcess(),
    Routes.login: (_) => LoginScreen(),
    Routes.importKey: (_) => const ImportKeyScreen(),
    Routes.recoverAccount: (_) => const RecoverAccountScreen(),
    Routes.recoverAccountFound: (_) => const RecoverAccountFoundScreen(),
    Routes.signup: (_) => const SignupScreen(null),
    // Routes.importAccount: (_) => ImportAccount(),
    // Routes.createAccount: (args) => CreateAccount(args),
    // Routes.showInvite: (args) => ShowInvite(args),
    // Routes.claimCode: (_) => ClaimCode(),
    // Routes.welcome: (args) => Welcome(args),
  };

  final appRoutes = {
    Routes.profile: (_) => ProfileScreen(),
    Routes.transferForm: (args) => TransferForm(args),
    Routes.transfer: (_) => SendSearchUserScreen(),
    Routes.sendEnterData: (_) => SendEnterDataScreen(),
    Routes.invites: (_) => Invites(),
    Routes.createInvite: (_) => const InviteScreen(),
    Routes.vote: (_) => const VoteScreen(),
    Routes.proposalDetails: (_) => const ProposalDetailsScreen(),
    Routes.logout: (_) => Logout(),
    Routes.imageViewer: (args) => ImageViewer(
          arguments: args,
        ),
    Routes.plantSeeds: (_) => const PlantSeedsScreen(),
    Routes.sendConfirmationScreen: (args) => const SendConfirmationScreen(),
    Routes.scanQRCode: (_) => SendScannerScreen(),
    Routes.receiveScreen: (_) => ReceiveScreen(),
    Routes.receiveEnterDataScreen: (_) => ReceiveEnterDataScreen(),
    Routes.receive: (_) => const Receive(),
    Routes.receiveConfirmation: (args) => ReceiveConfirmation(cart: args),
    Routes.receiveCustom: (_) => const ReceiveCustom(),
    Routes.receiveQR: (args) => ReceiveDetailQrCodeScreen(args),
    Routes.selectGuardians: (_) => SelectGuardiansScreen(),
    Routes.inviteGuardians: (args) => InviteGuardians(),
    Routes.inviteGuardiansSent: (_) => InviteGuardiansSentScreen(),
    Routes.guardianTabs: (_) => GuardiansScreen(),
    Routes.dho: (_) => DHO(),
    Routes.guardians: (_) => Guardians(),
    Routes.support: (_) => const SupportScreen(),
    Routes.security: (_) => const SecurityScreen(),
    Routes.editName: (_) => const EditNameScreen(),
    Routes.setCurrency: (_) => const SetCurrencyScreen(),
    Routes.citizenship: (_) => const CitizenshipScreen(),
    Routes.contribution: (_) => const ContributionScreen(),
    Routes.verification: (_) => const VerificationScreen(),
  };

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
    var routeName = settings.name;
    var arguments = settings.arguments;

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
        builder: (context) => PageNotFound(
          routeName: settings.name!,
          args: settings.arguments,
        ),
      );
    }
  }

  static RoutePredicate predicateForName(String name) {
    return (Route<dynamic> route) {
      //print("Route: ${route.settings.name}" + " modal: ${route is ModalRoute} handlepop: ${route.willHandlePopInternally}");
      if (route.settings.name == '/' && name != '/') {
        print('pop error: Route name not found: ' + name);
      }
      return !route.willHandlePopInternally && route is ModalRoute && route.settings.name == name ||
          route.settings.name == '/';
    };
  }
}
