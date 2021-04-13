

import 'dart:async';

class _Transition {
  final Events? event;
  final States? targetState;
  Map<String, dynamic>? data;

  _Transition({this.event, this.targetState});
}

class _State {
  final States? name;
  final List<_Transition>? transitions;

  _State({this.name, this.transitions});
}

enum Events {
  foundInviteLink,
  foundNoLink,
  foundInviteDetails,
  foundNoInvite,
  inviteAccepted,
  inviteRejected,
  createAccountCanceled,
  createAccountNameEntered,
  createAccountAccountNameBack,
  claimInviteCanceled,
  importAccountCanceled,
  chosenImportAccount,
  chosenClaimInvite,
  chosenRecoverAccount,
  accountCreated,
  accountImported,
  createAccountRequested,
  createAccountRequestedFinal,
  importAccountRequested,
  createAccountFailed,
  importAccountFailed,
  claimInviteRequested,
  foundRecoveryFlag,
  recoverCanceled,
  recoverAccountRequested,
  recoveryStartSuccess,
  recoveryStartFailed,
  foundValidRecovery,
  cancelRecoveryProcess,
  claimRecoveredAccount,
}

enum States {
  checkingInviteLink,
  processingInviteLink,
  onboardingMethodChoice,
  inviteConfirmation,
  createAccountEnterName,
  createAccountAccountName,
  importAccount,
  claimInviteCode,
  creatingAccount,
  importingAccount,
  finishOnboarding,
  checkRecoveryProcess,
  startRecovery,
  continueRecovery,
  recoverAccountState,
  continueRecoveryProcess,
  canceledRecoveryProcess,
}

class OnboardingStateMachine {
  StreamController<Map<String, dynamic>> _streamController =
      StreamController<Map<String, dynamic>>();

  States? currentState = States.checkingInviteLink;

  Map<States, _State> states = {
    States.checkingInviteLink: _State(
      name: States.checkingInviteLink,
      transitions: [
        _Transition(
          event: Events.foundInviteLink,
          targetState: States.processingInviteLink,
        ),
        _Transition(
          event: Events.foundNoLink,
          targetState: States.onboardingMethodChoice,
        ),
        _Transition(
          event: Events.foundRecoveryFlag,
          targetState: States.continueRecovery,
        ),
      ],
    ),
    States.processingInviteLink: _State(
      name: States.processingInviteLink,
      transitions: [
        _Transition(
          event: Events.foundInviteDetails,
          targetState: States.inviteConfirmation,
        ),
        _Transition(
          event: Events.foundNoInvite,
          targetState: States.onboardingMethodChoice,
        ),
      ],
    ),
    States.inviteConfirmation: _State(
      name: States.inviteConfirmation,
      transitions: [
        _Transition(
          event: Events.inviteAccepted,
          targetState: States.createAccountEnterName,
        ),
        _Transition(
          event: Events.inviteRejected,
          targetState: States.onboardingMethodChoice,
        )
      ],
    ),
    States.createAccountEnterName: _State(
      name: States.createAccountEnterName,
      transitions: [
        _Transition(
          event: Events.createAccountCanceled,
          targetState: States.onboardingMethodChoice,
        ),
        _Transition(
          event: Events.createAccountNameEntered,
          targetState: States.createAccountAccountName,
        ),
      ],
    ),
    States.createAccountAccountName: _State(
      name: States.createAccountAccountName,
      transitions: [
        _Transition(
          event: Events.createAccountAccountNameBack,
          targetState: States.createAccountEnterName,
        ),
        _Transition(
          event: Events.createAccountRequestedFinal,
          targetState: States.creatingAccount,
        ),
      ],
    ),
    States.claimInviteCode: _State(
      name: States.claimInviteCode,
      transitions: [
        _Transition(
          event: Events.claimInviteCanceled,
          targetState: States.onboardingMethodChoice,
        ),
        _Transition(
          event: Events.claimInviteRequested,
          targetState: States.inviteConfirmation,
        ),
      ],
    ),
    States.onboardingMethodChoice: _State(
      name: States.onboardingMethodChoice,
      transitions: [
        _Transition(
          event: Events.chosenImportAccount,
          targetState: States.importAccount,
        ),
        _Transition(
          event: Events.chosenClaimInvite,
          targetState: States.claimInviteCode,
        ),
        _Transition(
          event: Events.foundInviteLink,
          targetState: States.processingInviteLink,
        ),
        _Transition(
          event: Events.chosenRecoverAccount,
          targetState: States.startRecovery,
        ),
        _Transition(
          event: Events.foundRecoveryFlag,
          targetState: States.continueRecovery,
        ),
      ],
    ),
    States.startRecovery: _State(
      name: States.startRecovery,
      transitions: [
        _Transition(
            event: Events.cancelRecoveryProcess,
            targetState: States.onboardingMethodChoice),
        _Transition(
          event: Events.recoverCanceled,
          targetState: States.onboardingMethodChoice,
        ),
        _Transition(
          event: Events.recoverAccountRequested,
          targetState: States.continueRecovery,
        ),
        _Transition(
            event: Events.recoveryStartSuccess,
            targetState: States.onboardingMethodChoice),
        _Transition(
            event: Events.recoveryStartFailed,
            targetState: States.onboardingMethodChoice),
      ],
    ),
    States.checkRecoveryProcess: _State(
      name: States.checkRecoveryProcess,
      transitions: [
        _Transition(
          event: Events.foundValidRecovery,
          targetState: States.continueRecovery,
        ),
      ],
    ),
    States.continueRecovery: _State(
      name: States.continueRecovery,
      transitions: [
        _Transition(
            event: Events.cancelRecoveryProcess,
            targetState: States.onboardingMethodChoice),
        _Transition(
            event: Events.claimRecoveredAccount,
            targetState: States.recoverAccountState),
      ],
    ),
    States.importAccount: _State(
      name: States.importAccount,
      transitions: [
        _Transition(
          event: Events.importAccountCanceled,
          targetState: States.onboardingMethodChoice,
        ),
        _Transition(
          event: Events.importAccountRequested,
          targetState: States.importingAccount,
        ),
      ],
    ),
    States.importingAccount: _State(
      name: States.importingAccount,
      transitions: [
        _Transition(
          event: Events.accountImported,
          targetState: States.finishOnboarding,
        ),
        _Transition(
          event: Events.importAccountFailed,
          targetState: States.onboardingMethodChoice,
        ),
      ],
    ),
    States.creatingAccount: _State(
      name: States.creatingAccount,
      transitions: [
        _Transition(
          event: Events.accountCreated,
          targetState: States.finishOnboarding,
        ),
        _Transition(
          event: Events.createAccountFailed,
          targetState: States.onboardingMethodChoice,
        ),
      ],
    ),
  };

  void transition(Events event, {Map<String, dynamic>? data}) {
    var targetTransition =
        states[currentState!]!.transitions!.firstWhere((t) => t.event == event);

    print("event: $event  ---> ${targetTransition.targetState}");

    if (targetTransition != null) {
      currentState = targetTransition.targetState;
      _streamController.add({
        "event": event,
        "data": data,
      });
    } else {
      throw IllegalStateTransition(state: currentState, event: event);
    }
  }

  void listen(Function callback) {
    _streamController.stream.listen(callback as void Function(Map<String, dynamic>)?);
  }

  void dispose() {
    _streamController.close();
  }
}

class IllegalStateTransition implements Exception {
  States? state;
  Events? event;

  IllegalStateTransition({this.state, this.event});

  String get message => "cannot transition from state $state via event $event";

  @override
  String toString() {
    return "IllegalStateTransition: $message";
  }
}
