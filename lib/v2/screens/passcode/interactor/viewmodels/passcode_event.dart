import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class PasscodeEvent extends Equatable {
  const PasscodeEvent();
  @override
  List<Object> get props => [];
}

class DefineView extends PasscodeEvent {
  const DefineView();
  @override
  String toString() => 'DefineView';
}

class OnVerifyPasscode extends PasscodeEvent {
  final String passcode;
  const OnVerifyPasscode({@required this.passcode}) : assert(passcode != null);
  @override
  String toString() => 'OnVerifyPasscode { passcode: $passcode }';
}

class OnValidVerifyPasscode extends PasscodeEvent {
  const OnValidVerifyPasscode();
  @override
  String toString() => 'OnValidVerifyPasscode';
}

class OnCreatePasscode extends PasscodeEvent {
  final String passcode;
  const OnCreatePasscode({@required this.passcode}) : assert(passcode != null);
  @override
  String toString() => 'OnCreatePasscode { passcode: $passcode }';
}
