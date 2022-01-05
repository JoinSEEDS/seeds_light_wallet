part of 'deeplink_bloc.dart';

abstract class DeeplinkEvent extends Equatable {
  const DeeplinkEvent();

  @override
  List<Object?> get props => [];
}

class HandleIncomingFirebaseDeepLink extends DeeplinkEvent {
  final Uri newLink;

  const HandleIncomingFirebaseDeepLink(this.newLink);

  @override
  String toString() => 'HandleIncomingFirebaseDeepLink';
}

class OnGuardianRecoveryRequestSeen extends DeeplinkEvent {
  const OnGuardianRecoveryRequestSeen();

  @override
  String toString() => 'OnGuardianRecoveryRequestSeen';
}

class ClearDeepLink extends DeeplinkEvent {
  const ClearDeepLink();

  @override
  String toString() => 'ClearDeepLink';
}

class HandleIncomingSigningRequest extends DeeplinkEvent {
  final String link;

  const HandleIncomingSigningRequest(this.link);

  @override
  String toString() => 'HandleIncomingSigningRequest: $link';
}
