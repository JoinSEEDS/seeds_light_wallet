import './export.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  SettingsNotifier settings;
  LinksService links;
  HttpService http;
  EosService eos;

  OnboardingBloc({
    this.settings,
    this.links,
    this.http,
    this.eos,
  }) : super(OnboardingState(step: Step.onboardingMethodChoice));

  Future<void> waiting() => Future.delayed(Duration(milliseconds: 1500));

  void init() {
    if (!checkRecoveryMode()) {
      checkInviteLink();
    }
  }

  void checkInviteLink() async {
    final dynamic result = await links.processInitialLink();

    if (result != null) {
      this.add(FoundInviteLink()..inviteMnemonic = result.inviteMnemonic);
    } else {
      this.add(FoundNoLink());

      links.onDynamicLink((queryParams) {
        this.add(
            FoundInviteLink()..inviteMnemonic = queryParams.inviteMnemonic);
      });
    }
  }

  bool checkRecoveryMode() {
    if (settings.inRecoveryMode == true) {
      this.add(FoundRecoveryFlag()
        ..accountName = settings.accountName
        ..privateKey = settings.privateKey);

      return true;
    }

    return false;
  }

  void validateInvite(String inviteMnemonic) async {
    await Future.delayed(Duration(milliseconds: 500), () {});

    final inviteSecret = secretFromMnemonic(inviteMnemonic);
    InviteModel invite = await findInvite(inviteSecret);

    if (invite.sponsor != null) {
      this.add(FoundInviteDetails()
        ..inviterAccount = invite.sponsor
        ..inviteCode = inviteMnemonic);
    } else {
      this.add(FoundNoInvite());
    }
  }

  Future<InviteModel> findInvite(String inviteSecret) async {
    String inviteHash = hashFromSecret(inviteSecret);
    return http.findInvite(inviteHash);
  }

  void finishRecoveryProcess() {
    settings.finishRecoveryProcess();
  }

  void enableRecoveryMode() {
    Future.delayed(Duration.zero).then((_) {
      final recoveryPrivateKey = EOSPrivateKey.fromRandom();

      settings.enableRecoveryMode(
        accountName: state.accountName,
        privateKey: recoveryPrivateKey.toString(),
      );
    });
  }

  void disableRecoveryMode() {
    settings.cancelRecoveryProcess();
  }

  void createAccountRequested() async {
    Future.delayed(Duration.zero).then((_) async {
      EOSPrivateKey privateKeyRaw = EOSPrivateKey.fromRandom();
      EOSPublicKey publicKey = privateKeyRaw.toEOSPublicKey();

      try {
        var response = await eos.acceptInvite(
          accountName: state.accountName,
          publicKey: publicKey.toString(),
          inviteSecret: state.inviteSecret,
          nickname: state.nickname,
        );

        if (response == null || response["transaction_id"] == null) {
          return this.add(CreateAccountFailed());
        }

        this.add(
          AccountCreated()..privateKey = privateKeyRaw.toString(),
        );
      } catch (err) {
        this.add(CreateAccountFailed());
      }
    });
  }

  void secureAccountWithPasscode() {
    waiting().then((_) {
      settings.saveAccount(state.accountName, state.privateKey.toString());
    });
  }

  void acceptInvite() {
    waiting().then((_) {
      this.add(InviteAccepted());
    });
  }

  void importAccount() {
    waiting().then((_) {
      settings.privateKeyBackedUp = true;
      this.add(AccountImported());
    });
  }

  void onEvent(OnboardingEvent event) {
    super.onEvent(event);

    print('onEvent ' + event.toString());

    if (event is FoundInviteLink) {
      validateInvite(event.inviteMnemonic);
    } else if (event is FoundInviteDetails) {
      acceptInvite();
    } else if (event is ClaimInviteRequested) {
      acceptInvite();
    } else if (event is ImportAccountRequested) {
      importAccount();
    } else if (event is CreateAccountRequestedFinal) {
      createAccountRequested();
    } else if (event is AccountCreated) {
      secureAccountWithPasscode();
    } else if (event is AccountImported) {
      secureAccountWithPasscode();
    } else if (event is StartRecoveryRequested) {
      enableRecoveryMode();
    } else if (event is ClaimRecoveredAccount) {
      finishRecoveryProcess();
    } else if (event is ContinueRecoveryCanceled) {
      disableRecoveryMode();
    } else if (event is OnboardingInit) {
      init();
    }
  }

  Stream<OnboardingState> mapEventToState(OnboardingEvent event) async* {
    print('mapEventToState ' + event.toString());

    if (event is FoundInviteLink) {
      yield state.nextStep(Step.processingInviteLink);
    } else if (event is FoundNoLink) {
      yield state.nextStep(Step.onboardingMethodChoice);
    } else if (event is FoundInviteDetails) {
      yield state.nextStep(Step.inviteConfirmation);
    } else if (event is FoundNoInvite) {
      yield state.nextStep(Step.onboardingMethodChoice);
    } else if (event is InviteAccepted) {
      yield state.nextStep(Step.createAccountEnterName);
    } else if (event is InviteRejected) {
      yield state.nextStep(Step.onboardingMethodChoice);
    } else if (event is CreateAccountNameEntered) {
      yield state.nextStep(
        Step.createAccountAccountName,
        nickname: event.nickname,
      );
    } else if (event is CreateAccountAccountNameBack) {
      yield state.nextStep(Step.createAccountEnterName);
    } else if (event is CreateAccountRequestedFinal) {
      yield state.nextStep(
        Step.creatingAccount,
        accountName: event.accountName,
        loaderNotion:
            "Create account %s...".i18n.fill(["${event.accountName}"]),
      );
    } else if (event is ClaimInviteRequested) {
      yield state.nextStep(
        Step.inviteConfirmation,
        inviteSecret: event.inviteSecret,
        inviterAccount: event.inviterAccount,
        loaderNotion:
            "Accept invite from %s...".i18n.fill(["${event.inviterAccount}"]),
      );
    } else if (event is ChosenImportAccount) {
      yield state.nextStep(Step.importAccount);
    } else if (event is ChosenClaimInvite) {
      yield state.nextStep(Step.claimInviteCode);
    } else if (event is FoundInviteLink) {
      yield state.nextStep(Step.processingInviteLink);
    } else if (event is ChosenRecoverAccount) {
      yield state.nextStep(Step.startRecovery);
    } else if (event is FoundRecoveryFlag) {
      yield state.nextStep(Step.continueRecovery);
    } else if (event is ImportAccountRequested) {
      yield state.nextStep(
        Step.importingAccount,
        accountName: event.accountName,
        privateKey: event.privateKey,
        loaderNotion:
            "Import account %s...".i18n.fill(["${event.accountName}"]),
      );
    } else if (event is AccountImported) {
      yield state.nextStep(Step.finishOnboarding);
    } else if (event is ImportAccountFailed) {
      yield state.nextStep(Step.onboardingMethodChoice);
    } else if (event is AccountCreated) {
      yield state.nextStep(
        Step.finishOnboarding,
        privateKey: event.privateKey,
      );
    } else if (event is CreateAccountFailed) {
      yield state.nextStep(Step.onboardingMethodChoice);
    } else if (event is StartRecoveryRequested) {
      yield state.nextStep(Step.recoveryStarting);
    } else if (event is ContinueRecoveryCanceled) {
      yield state.nextStep(Step.recoveryCanceling);
    } else if (event is ClaimRecoveredAccount) {
      yield state.nextStep(Step.recoveryClaiming);
    } else if (event is ClaimFailed) {
      yield state.nextStep(Step.onboardingMethodChoice);
    } else if (event is OnboardingInit) {
      yield state.nextStep(Step.onboardingMethodChoice);
    } else if (event is BackPressed) {
      yield state.nextStep(Step.onboardingMethodChoice);
    } else {
      addError(Exception('unsupported event'));
    }
  }
}
