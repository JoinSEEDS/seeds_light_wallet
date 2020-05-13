import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/services/links_service.dart';
import 'package:seeds/screens/onboarding/claim_code.dart';
import 'package:seeds/screens/onboarding/create_account.dart';
import 'package:seeds/screens/onboarding/import_account.dart';
import 'package:seeds/screens/onboarding/onboarding_state_machine.dart';
import 'package:seeds/screens/onboarding/show_onboarding_choice.dart';
import 'package:seeds/utils/invites.dart';
import 'package:seeds/widgets/notion_loader.dart';
import 'package:seeds/widgets/overlay_popup.dart';

class JoinProcess extends StatefulWidget {
  @override
  _JoinProcessState createState() => _JoinProcessState();
}

class _JoinProcessState extends State<JoinProcess> {
  final machine = OnboardingStateMachine();

  String nickname;
  String accountName;
  String privateKey;
  String inviteCode;
  String inviteSecret;
  String inviterAccount;

  @override
  void initState() {
    machine.listen((transition) {
      setState(() {
        var data = transition["data"];

        if (data != null) {
          if (data["nickname"] != null) {
            nickname = data["nickname"];
          }

          if (data["accountName"] != null) {
            accountName = data["accountName"];
          }

          if (data["inviterAccount"] != null) {
            inviterAccount = data["inviterAccount"];
          }

          if (data["privateKey"] != null) {
            privateKey = data["privateKey"];
          }

          if (data["inviteSecret"] != null) {
            inviteSecret = data["inviteSecret"];
          }
        }
      });

      if (transition["event"] == Events.foundInviteLink) {
        validateInvite(transition["data"]["inviteMnemonic"]);
      }

      if (transition["event"] == Events.foundInviteDetails) {
        acceptInvite();
      }

      if (transition["event"] == Events.claimInviteRequested) {
        acceptInvite();
      }

      if (transition["event"] == Events.importAccountRequested) {
        importAccount();
      }

      if (transition["event"] == Events.createAccountRequested) {
        createAccount();
      }

      if (transition["event"] == Events.accountCreated ||
          transition["event"] == Events.accountImported) {
        secureAccountWithPasscode();
      }
    });
    listenInviteLink();
    super.initState();
  }

  void secureAccountWithPasscode() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    SettingsNotifier.of(context).saveAccount(
      accountName,
      privateKey.toString(),
    );
  }

  void importAccount() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    SettingsNotifier.of(context).privateKeyBackedUp = true;
    machine.transition(Events.accountImported);
  }

  void acceptInvite() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    machine.transition(Events.inviteAccepted);
  }

  void createAccount() async {
    await Future.delayed(Duration(milliseconds: 500), () {});

    EOSPrivateKey privateKeyRaw = EOSPrivateKey.fromRandom();
    EOSPublicKey publicKey = privateKeyRaw.toEOSPublicKey();

    privateKey = privateKeyRaw.toString();

    try {
      var response = await Provider.of<EosService>(
        context,
        listen: false,
      ).acceptInvite(
        accountName: accountName,
        publicKey: publicKey.toString(),
        inviteSecret: inviteSecret,
        nickname: nickname,
      );

      if (response == null || response["transaction_id"] == null) {
        return machine.transition(Events.createAccountFailed);
      }

      machine.transition(Events.accountCreated);
    } catch (err) {
      print(err);
      machine.transition(Events.createAccountFailed);
    }
  }

  void validateInvite(String inviteMnemonic) async {
    await Future.delayed(Duration(milliseconds: 500), () {});
    inviteCode = inviteMnemonic;
    inviteSecret = secretFromMnemonic(inviteMnemonic);

    InviteModel invite = await findInvite(inviteSecret);
    if (invite.sponsor != null) {
      machine.transition(
        Events.foundInviteDetails,
        data: {"inviterAccount": invite.sponsor},
      );
    } else {
      machine.transition(Events.foundNoInvite);
    }
  }

  Future<InviteModel> findInvite(String inviteSecret) async {
    String inviteHash = hashFromSecret(inviteSecret);
    return HttpService.of(context).findInvite(inviteHash);
  }

  void listenInviteLink() async {
    await Future.delayed(Duration(milliseconds: 500), () {});

    final dynamic result =
        await Provider.of<LinksService>(context, listen: false)
            .processInitialLink();

    if (result != null) {
      machine.transition(Events.foundInviteLink, data: result);
    } else {
      machine.transition(Events.foundNoLink);

      Provider.of<LinksService>(context, listen: false)
          .onDynamicLink((queryParams) {
        machine.transition(Events.foundInviteLink, data: queryParams);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;
    Function backCallback;

    switch (machine.currentState) {
      case States.checkingInviteLink:
        currentScreen = NotionLoader(
          notion: "Initialize new wallet...",
        );
        break;
      case States.processingInviteLink:
        currentScreen = NotionLoader(
          notion: "Process invite link...",
        );
        break;
      case States.inviteConfirmation:
        currentScreen = NotionLoader(
          notion: "Accept invite from $inviterAccount...",
        );
        break;
      case States.claimInviteCode:
        currentScreen = ClaimCode(
          inviteCode: inviteCode,
          onClaim: ({inviteSecret, inviterAccount}) => machine.transition(
            Events.claimInviteRequested,
            data: {
              "inviteSecret": inviteSecret,
              "inviterAccount": inviterAccount,
            },
          ),
        );
        backCallback = () => machine.transition(Events.claimInviteCanceled);
        break;
      case States.createAccount:
        currentScreen = CreateAccount(
          inviteSecret: inviteSecret,
          onSubmit: (accountName, nickName) => machine.transition(
            Events.createAccountRequested,
            data: {
              "accountName": accountName,
              "nickname": nickName,
            },
          ),
        );
        backCallback = () => machine.transition(Events.createAccountCanceled);
        break;
      case States.creatingAccount:
        currentScreen = NotionLoader(
          notion: "Create account $accountName...",
        );
        break;
      case States.importingAccount:
        currentScreen = NotionLoader(
          notion: "Import account $accountName...",
        );
        break;
      case States.finishOnboarding:
        currentScreen = NotionLoader(
          notion: "Secure wallet $accountName...",
        );
        break;
      case States.importAccount:
        currentScreen = ImportAccount(
          onImport: ({accountName, privateKey}) => machine.transition(
            Events.importAccountRequested,
            data: {"accountName": accountName, "privateKey": privateKey},
          ),
        );
        backCallback = () => machine.transition(Events.importAccountCanceled);
        break;
      case States.onboardingMethodChoice:
        currentScreen = ShowOnboardingChoice(
          onInvite: () => machine.transition(Events.chosenClaimInvite),
          onImport: () => machine.transition(Events.chosenImportAccount),
        );
        break;
    }

    return OverlayPopup(body: currentScreen, backCallback: backCallback);
  }
}
