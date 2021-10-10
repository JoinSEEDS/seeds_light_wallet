import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/authentication/import_key/import_key_screen.dart';
import 'package:seeds/screens/authentication/import_key/import_words_screen.dart';
import 'package:seeds/screens/authentication/loading_screen.dart';
import 'package:seeds/screens/authentication/login_screen.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/recover_account_found_screen.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/recover_account_screen.dart';
import 'package:seeds/screens/authentication/sign_up/signup_screen.dart';
import 'package:seeds/screens/authentication/verification/verification_screen.dart';
import 'package:seeds/screens/explore_screens/invite/invite_screen.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/plant_seeds_screen.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/unplant_seeds_screen.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegate_screen.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/delegate_a_user_screen.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/proposal_details_screen.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/vote_screen.dart';
import 'package:seeds/screens/onboarding/onboarding_screen.dart';
import 'package:seeds/screens/page_not_found_screen.dart';
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
import 'package:seeds/screens/transfer/receive/receive_detail_qr_code/receive_detail_qr_code.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/receive_seeds_screen.dart';
import 'package:seeds/screens/transfer/receive/receive_selection/receive_screen.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/send_confirmation_screen.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/send_enter_data_screen.dart';
import 'package:seeds/screens/transfer/send/send_scanner/send_scanner_screen.dart';
import 'package:seeds/screens/transfer/send/send_search_user/send_search_user_screen.dart';

class Routes {
  static const onboarding = 'Onboarding';
  static const loading = 'loading';
  static const app = 'app';
  static const login = "Login";
  static const importKey = "ImportKey";
  static const importWords = 'ImportWords';
  static const verification = "verification";
  static const signup = 'signUp';
  static const recoverAccount = 'recoverAccount';
  static const recoveryPhrase = 'recoveryPhrase';
  static const recoverAccountFound = 'recoverAccountFound';
  static const createAccount = 'CreateAccount';
  static const showInvite = 'ShowInvite';
  static const claimCode = 'ClaimCode';
  static const welcome = 'Welcome';
  static const transfer = 'Transfer';
  static const sendEnterData = 'SendEnterData';
  static const delegate = 'delegate';
  static const delegateAUser = 'delegateAUser';
  static const createInvite = 'CreateInvite';
  static const vote = 'vote';
  static const proposalDetails = 'ProposalDetails';
  static const overview = 'Overview';
  static const plantSeeds = 'plantSeeds';
  static const unPlantSeeds = 'unPlantSeeds';
  static const sendConfirmationScreen = 'SendConfirmationScreen';
  static const scanQRCode = 'ScanQRCode';
  static const receiveScreen = "receiveScreen";
  static const receiveEnterDataScreen = "receiveEnterDataScreen";
  static const receiveQR = 'ReceiveQR';
  static const profile = 'profile';
  static const selectGuardians = 'SelectGuardians';
  static const inviteGuardians = 'InviteGuardians';
  static const inviteGuardiansSent = 'InviteGuardiansSent';
  static const guardianTabs = 'GuardianTabs';
  static const support = 'Support';
  static const security = 'Security';
  static const editName = 'EditName';
  static const setCurrency = "SetCurrency";
  static const citizenship = 'CitizenShip';
  static const contribution = 'Contribution';
}

class NavigationService {
  final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
  final _appRoutes = {
    Routes.onboarding: (_) => const OnboardingScreen(),
    Routes.loading: () => const LoadingScreen(),
    Routes.login: (_) => const LoginScreen(),
    Routes.importKey: (_) => const ImportKeyScreen(),
    Routes.importWords: (_) => const ImportWordsScreen(),
    Routes.recoverAccount: (_) => const RecoverAccountScreen(),
    Routes.recoverAccountFound: (_) => const RecoverAccountFoundScreen(),
    Routes.signup: (_) => const SignupScreen(),
    Routes.app: (_) => const App(),
    Routes.transfer: (_) => const SendSearchUserScreen(),
    Routes.sendEnterData: (_) => const SendEnterDataScreen(),
    Routes.createInvite: (_) => const InviteScreen(),
    Routes.vote: (_) => const VoteScreen(),
    Routes.delegate: (_) => const DelegateScreen(),
    Routes.delegateAUser: (_) => const DelegateAUserScreen(),
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
    Routes.profile: (_) => const ProfileScreen(),
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
  final _fullScreenRoutes = {
    Routes.verification,
  };
  StreamController<String>? _streamRouteListener;

  static NavigationService of(BuildContext context, {bool listen = false}) =>
      Provider.of<NavigationService>(context, listen: listen);

  // ignore: use_setters_to_change_properties
  void addListener(StreamController<String> listener) {
    _streamRouteListener = listener;
  }

  Future<dynamic> navigateTo(String routeName, [Object? arguments, bool replace = false]) async {
    if (_streamRouteListener != null) {
      _streamRouteListener?.add(routeName);
    }

    if (_appRoutes[routeName] != null) {
      if (replace) {
        return appNavigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
      } else {
        return appNavigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
      }
    }
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (_appRoutes[settings.name!] != null) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => _appRoutes[settings.name]!(settings.arguments),
        fullscreenDialog: _fullScreenRoutes.contains(settings.name),
      );
    } else {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => PageNotFoundScreen(routeName: settings.name!, args: settings.arguments),
      );
    }
  }

  Future<dynamic> pushAndRemoveAll(String routeName, [Object? arguments]) async {
    return appNavigatorKey.currentState?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }
}
