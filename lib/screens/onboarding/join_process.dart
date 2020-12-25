import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/services/links_service.dart';
import 'package:seeds/screens/onboarding/claim_code.dart';
import 'package:seeds/screens/onboarding/continue_recovery.dart';
import 'package:seeds/screens/onboarding/create_account.dart';
import 'package:seeds/screens/onboarding/create_account_account_name.dart';
import 'package:seeds/screens/onboarding/import_account.dart';
import 'package:seeds/screens/onboarding/onboarding_state_machine.dart';
import 'package:seeds/screens/onboarding/request_recovery.dart';
import 'package:seeds/screens/onboarding/show_onboarding_choice.dart';
import 'package:seeds/utils/invites.dart';
import 'package:seeds/widgets/notion_loader.dart';
import 'package:seeds/widgets/overlay_popup.dart';
import 'package:seeds/i18n/join_process.i18n.dart';

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

      if (transition["event"] == Events.claimRecoveredAccount) {
        finishRecoveryProcess();
      }

      if (transition["event"] == Events.cancelRecoveryProcess) {
        disableRecoveryMode();
      }

      if (transition["event"] == Events.recoverAccountRequested) {
        enableRecoveryMode();
      }

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

      if (transition["event"] == Events.createAccountRequestedFinal) {
        createAccountRequested();
      }

      if (transition["event"] == Events.accountCreated ||
          transition["event"] == Events.accountImported) {
        secureAccountWithPasscode();
      }
    });
    listenInviteLink();
    checkRecoveryMode();
    super.initState();
  }

  void finishRecoveryProcess() {
    SettingsNotifier.of(context).finishRecoveryProcess();
  }

  void enableRecoveryMode() {
    final recoveryPrivateKey = EOSPrivateKey.fromRandom();

    SettingsNotifier.of(context).enableRecoveryMode(
      accountName: accountName,
      privateKey: recoveryPrivateKey.toString(),
    );
  }

  void disableRecoveryMode() {
    SettingsNotifier.of(context).cancelRecoveryProcess();
  }

  void checkRecoveryMode() async {
    await Future.delayed(Duration(milliseconds: 500), () {});

    if (SettingsNotifier.of(context).inRecoveryMode == true) {
      machine.transition(Events.foundRecoveryFlag, data: {
        "accountName": SettingsNotifier.of(context).accountName,
        "privateKey": SettingsNotifier.of(context).privateKey,
      });
    }
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

  void createAccountRequested() async {
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
      if (machine.currentState == States.checkingInviteLink) {
        machine.transition(Events.foundNoLink);
      }

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
      case States.startRecovery:
        currentScreen = RequestRecovery(
          onRequestRecovery: (String accountName) =>
              machine.transition(Events.recoverAccountRequested, data: {
            "accountName": accountName,
          }),
        );
        backCallback = () => machine.transition(Events.cancelRecoveryProcess);
        break;
      case States.canceledRecoveryProcess:
        currentScreen = NotionLoader(notion: "Cancel recovery process...");
        break;
      case States.continueRecovery:
        currentScreen = ContinueRecovery(
          accountName: accountName,
          privateKey: privateKey,
          onClaimed: () => machine.transition(Events.claimRecoveredAccount),
          onBack: () => machine.transition(Events.cancelRecoveryProcess),
        );
        backCallback = () => machine.transition(Events.cancelRecoveryProcess);
        break;
      case States.recoverAccount:
        currentScreen = NotionLoader(
          notion: "Recover account started...".i18n,
        );
        break;
      case States.checkRecoveryProcess:
        currentScreen = NotionLoader(
          notion: "Recovery process analyzing...".i18n,
        );
        break;
      case States.continueRecoveryProcess:
        currentScreen = NotionLoader(
          notion: "Continue recovery process...".i18n,
        );
        break;
      case States.checkingInviteLink:
        currentScreen = NotionLoader(
          notion: "Initialize new wallet...".i18n,
        );
        break;
      case States.processingInviteLink:
        currentScreen = NotionLoader(
          notion: "Process invite link...".i18n,
        );
        break;
      case States.inviteConfirmation:
        currentScreen = NotionLoader(
          notion: "Accept invite from %s...".i18n.fill(["$inviterAccount"]),
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
      case States.createAccountEnterName:
        currentScreen = CreateAccount(
          inviteSecret: inviteSecret,
          initialName: nickname,
          onSubmit: (nickName) => machine.transition(
            Events.createAccountNameEntered,
            data: {
              "nickname": nickName,
            },
          ),
        );
        backCallback = () => machine.transition(Events.createAccountCanceled);
        break;
      case States.createAccountAccountName:
        currentScreen = CreateAccountAccountName(
          nickname: nickname,
          onSubmit: (accountName, nickName) => machine.transition(
            Events.createAccountRequestedFinal,
            data: {
              "accountName": accountName,
              "nickname": nickName,
            },
          ),
        );
        backCallback =
            () => machine.transition(Events.createAccountAccountNameBack);
        break;
      case States.creatingAccount:
        currentScreen = NotionLoader(
          notion: "Create account %s...".i18n.fill(["$accountName"]),
        );
        break;
      case States.importingAccount:
        currentScreen = NotionLoader(
          notion: "Import account %s...".i18n.fill(["$accountName"]),
        );
        break;
      case States.finishOnboarding:
        currentScreen = NotionLoader(
          notion: "Secure wallet %s...".i18n.fill(["$accountName"]),
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
          onRecover: () => machine.transition(Events.chosenRecoverAccount),
        );
        break;
    }

    return OverlayPopup(body: currentScreen, backCallback: backCallback);
  }
}

class InitRecovery extends StatefulWidget {
  @override
  _InitRecoveryState createState() => _InitRecoveryState();

  InitRecovery({Function onSubmit});
}

class _InitRecoveryState extends State<InitRecovery> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
