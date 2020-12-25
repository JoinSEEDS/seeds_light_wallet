import './export.dart';

class OnboardingState {
  OnboardingState({
    @required this.step,
    this.nickname,
    this.accountName,
    this.privateKey,
    this.inviteCode,
    this.inviteSecret,
    this.inviterAccount,
    this.loaderNotion,
  });

  final Step step;
  final String nickname;
  final String accountName;
  final String privateKey;
  final String inviteCode;
  final String inviteSecret;
  final String inviterAccount;
  final String loaderNotion;

  OnboardingState nextStep(
    Step step, {
    nickname,
    accountName,
    privateKey,
    inviteCode,
    inviteSecret,
    inviterAccount,
    loaderNotion,
  }) {
    return OnboardingState(
      step: step,
      nickname: nickname ?? this.nickname,
      accountName: accountName ?? this.accountName,
      privateKey: privateKey ?? this.privateKey,
      inviteCode: inviteCode ?? this.inviteCode,
      inviteSecret: inviteSecret ?? this.inviteSecret,
      inviterAccount: inviterAccount ?? this.inviterAccount,
      loaderNotion: loaderNotion ?? this.loaderNotion,
    );
  }
}
