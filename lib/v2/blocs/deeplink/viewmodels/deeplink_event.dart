import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class DeeplinkEvent extends Equatable {
  const DeeplinkEvent();

  @override
  List<Object> get props => [];
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