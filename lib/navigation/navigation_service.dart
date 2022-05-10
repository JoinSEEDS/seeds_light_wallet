import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/screens/app/app.dart';
import 'package:seeds/screens/authentication/import_key/import_key_screen.dart';
import 'package:seeds/screens/authentication/import_key/import_words_screen.dart';
import 'package:seeds/screens/authentication/login_screen.dart';
import 'package:seeds/screens/authentication/onboarding/onboarding_screen.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/recover_account_found_screen.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/recover_account_search_screen.dart';
import 'package:seeds/screens/authentication/sign_up/signup_screen.dart';
import 'package:seeds/screens/authentication/splash_screen.dart';
import 'package:seeds/screens/authentication/verification/verification_screen.dart';
import 'package:seeds/screens/explore_screens/flag/flag_user/flag_user_screen.dart';
import 'package:seeds/screens/explore_screens/flag/flags/flag_screen.dart';
import 'package:seeds/screens/explore_screens/invite/invite_screen.dart';
import 'package:seeds/screens/explore_screens/manage_invites/manage_invites_screen.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/plant_seeds_screen.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_event_screens/create_region_event_screen_controller.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/create_region_screen_controller.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/edit_region_description.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region/edit_region_image.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/edit_region_event_image.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/edit_region_event_location.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/edit_region_event_name_and_description.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/edit_region_event_time_and_date.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/join_region_screen.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/region_event_details_screen.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/region_screen.dart';
import 'package:seeds/screens/explore_screens/swap_seeds/swap_seeds_screen.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/unplant_seeds_screen.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegate_screen.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/delegate_a_user_screen.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposal_details/proposal_details_screen.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/vote_screen.dart';
import 'package:seeds/screens/explore_screens/vouch/vouch_for_a_member/vouch_for_a_member_screen.dart';
import 'package:seeds/screens/explore_screens/vouch/vouch_screen.dart';
import 'package:seeds/screens/profile_screens/citizenship/citizenship_screen.dart';
import 'package:seeds/screens/profile_screens/contribution/contribution_detail/contribution_detail_screen.dart';
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
import 'package:seeds/screens/transfer/send/send_confirmation/transaction_actions_screen.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/send_enter_data_screen.dart';
import 'package:seeds/screens/transfer/send/send_scanner/send_scanner_screen.dart';
import 'package:seeds/screens/transfer/send/send_search_user/send_search_user_screen.dart';

/// Add only current routes in the app and that are used by [NavigationService]
class Routes {
  static const onboarding = 'onboarding';
  static const splash = 'splash';
  static const app = 'app';
  static const login = 'login';
  static const importKey = 'importKey';
  static const importWords = 'importWords';
  static const verification = 'verification';
  static const signup = 'signup';
  static const recoverAccountSearch = 'recoverAccountSearch';
  static const recoveryPhrase = 'recoveryPhrase';
  static const recoverAccountFound = 'recoverAccountFound';
  static const transfer = 'transfer';
  static const sendEnterData = 'sendEnterData';
  static const delegate = 'delegate';
  static const delegateAUser = 'delegateAUser';
  static const createInvite = 'createInvite';
  static const flag = 'flag';
  static const flagUser = 'flagUser';
  static const vote = 'vote';
  static const proposalDetails = 'proposalDetails';
  static const plantSeeds = 'plantSeeds';
  static const vouch = 'vouch';
  static const vouchForAMember = 'vouchForAMember';
  static const unPlantSeeds = 'unPlantSeeds';
  static const createRegion = 'createRegion';
  static const createRegionEvent = 'createRegionEvent';
  static const sendConfirmation = 'sendConfirmation';
  static const transactionActions = 'transactionActions';
  static const scanQRCode = 'scanQRCode';
  static const swapSeeds = 'swapSeeds';
  static const joinRegion = 'joinRegion';
  static const receiveScreen = 'receiveScreen'; // TODO(gguij002): Route not yet implemented
  static const receiveEnterData = 'receiveEnterData';
  static const receiveQR = 'receiveQR';
  static const profile = 'profile';
  static const selectGuardians = 'selectGuardians';
  static const inviteGuardians = 'inviteGuardians';
  static const inviteGuardiansSent = 'inviteGuardiansSent';
  static const guardianTabs = 'guardianTabs';
  static const manageInvites = 'manageInvites';
  static const support = 'support';
  static const security = 'security';
  static const editName = 'editName';
  static const setCurrency = 'setCurrency';
  static const citizenship = 'citizenship';
  static const contribution = 'contribution';
  static const contributionDetail = 'contributionDetail';
  static const region = 'region';
  static const regionEventDetails = 'regionEventDetials';
  static const editRegionDescription = 'editRegionDescription';
  static const editRegionImage = 'editRegionImage';
  static const editRegionEventNameAndDescription = 'editRegionEventNameAndDescription';
  static const editRegionEventLocation = 'editRegionEventLocation';
  static const editRegionEventTimeAndDate = 'editRegionEventTimeAndDate';
  static const editRegionEventImage = 'editRegionEventImage';
}

class NavigationService {
  final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
  final _appRoutes = {
    Routes.onboarding: (_) => const OnboardingScreen(),
    Routes.splash: (_) => const SplashScreen(),
    Routes.login: (_) => const LoginScreen(),
    Routes.importKey: (_) => const ImportKeyScreen(),
    Routes.importWords: (_) => const ImportWordsScreen(),
    Routes.recoverAccountSearch: (_) => const RecoverAccountSearchScreen(),
    Routes.recoverAccountFound: (_) => const RecoverAccountFoundScreen(),
    Routes.signup: (_) => const SignupScreen(),
    Routes.app: (_) => const App(),
    Routes.transfer: (_) => const SendSearchUserScreen(),
    Routes.sendEnterData: (_) => const SendEnterDataScreen(),
    Routes.createInvite: (_) => const InviteScreen(),
    Routes.vote: (_) => const VoteScreen(),
    Routes.flag: (_) => const FlagScreen(),
    Routes.flagUser: (_) => const FlagUserScreen(),
    Routes.delegate: (_) => const DelegateScreen(),
    Routes.delegateAUser: (_) => const DelegateAUserScreen(),
    Routes.proposalDetails: (_) => const ProposalDetailsScreen(),
    Routes.vouch: (_) => const VouchScreen(),
    Routes.vouchForAMember: (_) => const VouchForAMemberScreen(),
    Routes.plantSeeds: (_) => const PlantSeedsScreen(),
    Routes.unPlantSeeds: (_) => const UnplantSeedsScreen(),
    Routes.createRegion: (_) => const CreateRegionScreenController(),
    Routes.createRegionEvent: (_) => const CreateRegionEventScreenController(),
    Routes.sendConfirmation: (args) => const SendConfirmationScreen(),
    Routes.transactionActions: (_) => const TransactionActionsScreen(),
    Routes.scanQRCode: (_) => const SendScannerScreen(),
    Routes.swapSeeds: (_) => const SwapSeedsScreen(),
    Routes.joinRegion: (_) => const JoinRegionScreen(),
    Routes.receiveScreen: (_) => const ReceiveScreen(), // <- This route is not used
    Routes.receiveEnterData: (_) => const ReceiveEnterDataScreen(),
    Routes.receiveQR: (args) => ReceiveDetailQrCodeScreen(args),
    Routes.selectGuardians: (_) => const SelectGuardiansScreen(),
    Routes.inviteGuardians: (args) => const InviteGuardians(),
    Routes.inviteGuardiansSent: (_) => const InviteGuardiansSentScreen(),
    Routes.guardianTabs: (_) => const GuardiansScreen(),
    Routes.manageInvites: (_) => const ManageInvitesScreen(),
    Routes.profile: (_) => const ProfileScreen(),
    Routes.support: (_) => const SupportScreen(),
    Routes.security: (_) => const SecurityScreen(),
    Routes.editName: (_) => const EditNameScreen(),
    Routes.setCurrency: (_) => const SetCurrencyScreen(),
    Routes.citizenship: (_) => const CitizenshipScreen(),
    Routes.contribution: (_) => const ContributionScreen(),
    Routes.contributionDetail: (_) => const ContributionDetailScreen(),
    Routes.verification: (_) => const VerificationScreen(),
    Routes.recoveryPhrase: (_) => const RecoveryPhraseScreen(),
    Routes.region: (_) => const RegionScreen(),
    Routes.editRegionDescription: (_) => const EditRegionDescription(),
    Routes.editRegionImage: (_) => const EditRegionImage(),
    Routes.regionEventDetails: (_) => const RegionEventDetailsScreen(),
    Routes.editRegionEventNameAndDescription: (_) => const EditRegionEventNameAndDescription(),
    Routes.editRegionEventLocation: (_) => const EditRegionEventLocation(),
    Routes.editRegionEventTimeAndDate: (_) => const EditRegionEventTimeAndDate(),
    Routes.editRegionEventImage: (_) => const EditRegionEventImage(),
  };

  // iOS: full screen routes pop up from the bottom and disappear vertically too
  // On iOS that's a standard full screen dialog
  // Has no effect on Android.
  final _fullScreenRoutes = {
    Routes.verification,
  };

  // iOS transition: Pages that slides in from the right and exits in reverse.
  final _cupertinoRoutes = {
    Routes.citizenship,
  };
  StreamController<String>? _streamRouteListener;

  static NavigationService of(BuildContext context) => RepositoryProvider.of<NavigationService>(context);

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
      if (_cupertinoRoutes.contains(settings.name)) {
        // Pages that slides in from the right and exits in reverse
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => _appRoutes[settings.name]!(settings.arguments),
          fullscreenDialog: _fullScreenRoutes.contains(settings.name),
        );
      } else {
        // Pages slides the route upwards and fades it in, and exits in reverse
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => _appRoutes[settings.name]!(settings.arguments),
          fullscreenDialog: _fullScreenRoutes.contains(settings.name),
        );
      }
    } else {
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }

  Future<dynamic> pushAndRemoveAll(String routeName, [Object? arguments]) async {
    return appNavigatorKey.currentState?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  Future<dynamic> pushAndRemoveUntil({required String route, required String from, Object? arguments}) async {
    return appNavigatorKey.currentState?.pushNamedAndRemoveUntil(route, ModalRoute.withName(from));
  }
}
