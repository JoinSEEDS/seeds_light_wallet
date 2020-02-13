import 'dart:async';

class _Transition {
  final Events event;
  final States targetState;
  Map<String, dynamic> data;

  _Transition({this.event, this.targetState});
}

class _State {
  final States name;
  final List<_Transition> transitions;

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
  claimInviteCanceled,
  importAccountCanceled,
  chosenImportAccount,
  chosenClaimInvite,
  accountCreated,
  accountImported,
  createAccountRequested,
  importAccountRequested,
  createAccountFailed,
  importAccountFailed,
  claimInviteRequested
}

enum States {
  checkingInviteLink,
  processingInviteLink,
  onboardingMethodChoice,
  inviteConfirmation,
  createAccount,
  importAccount,
  claimInviteCode,
  creatingAccount,
  importingAccount,
  finishOnboarding,
}

class OnboardingStateMachine {
  StreamController<Map<String, dynamic>> _streamController =
      StreamController<Map<String, dynamic>>();

  States currentState = States.checkingInviteLink;

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
          targetState: States.createAccount,
        ),
        _Transition(
          event: Events.inviteRejected,
          targetState: States.onboardingMethodChoice,
        )
      ],
    ),
    States.createAccount: _State(
      name: States.createAccount,
      transitions: [
        _Transition(
          event: Events.createAccountCanceled,
          targetState: States.onboardingMethodChoice,
        ),
        _Transition(
          event: Events.createAccountRequested,
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

  void transition(Events event, {Map<String, dynamic> data}) {
    var targetTransition =
        states[currentState].transitions.firstWhere((t) => t.event == event);

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
    _streamController.stream.listen(callback);
  }

  void dispose() {
    _streamController.close();
  }
}

class IllegalStateTransition implements Exception {
  States state;
  Events event;

  IllegalStateTransition({this.state, this.event});

  String get message => "cannot transition from state $state via event $event";

  @override
  String toString() {
    return "IllegalStateTransition: $message";
  }
}
