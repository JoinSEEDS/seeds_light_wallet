part of 'signup_bloc.dart';

enum SignupScreens { claimInvite, displayName, accountName }

enum ClaimInviteView { initial, scanner, processing, success, fail }

class SignupState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final SignUpError? error;
  final SignupScreens signupScreens;
  final ClaimInviteView claimInviteView;
  final InviteModel? inviteModel;
  final String? inviteMnemonic;
  final bool fromDeepLink;
  final String? accountName;
  final String? displayName;

  const SignupState({
    required this.pageState,
    this.pageCommand,
    this.error,
    required this.signupScreens,
    required this.claimInviteView,
    this.inviteModel,
    this.inviteMnemonic,
    required this.fromDeepLink,
    this.accountName,
    this.displayName,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        error,
        signupScreens,
        claimInviteView,
        inviteModel,
        inviteMnemonic,
        fromDeepLink,
        accountName,
        displayName,
      ];

  bool get isUsernameValid => !accountName.isNullOrEmpty && pageState == PageState.success;

  bool get isNextButtonActive => isUsernameValid;

  SignupState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    SignUpError? error,
    SignupScreens? signupScreens,
    ClaimInviteView? claimInviteView,
    InviteModel? inviteModel,
    String? inviteMnemonic,
    bool? fromDeepLink,
    String? accountName,
    String? displayName,
  }) =>
      SignupState(
        pageState: pageState ?? this.pageState,
        pageCommand: pageCommand,
        error: error,
        signupScreens: signupScreens ?? this.signupScreens,
        claimInviteView: claimInviteView ?? this.claimInviteView,
        inviteModel: inviteModel ?? this.inviteModel,
        inviteMnemonic: inviteMnemonic ?? this.inviteMnemonic,
        fromDeepLink: fromDeepLink ?? this.fromDeepLink,
        accountName: accountName ?? this.accountName,
        displayName: displayName ?? this.displayName,
      );

  factory SignupState.initial() {
    return const SignupState(
      pageState: PageState.initial,
      signupScreens: SignupScreens.claimInvite,
      claimInviteView: ClaimInviteView.initial,
      fromDeepLink: false,
    );
  }
}
