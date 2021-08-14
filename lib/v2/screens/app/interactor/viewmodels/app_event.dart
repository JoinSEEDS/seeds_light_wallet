import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:seeds/v2/datasource/local/models/scan_qr_code_result_data.dart';

/// --- EVENTS
@immutable
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class ShouldShowNotificationBadge extends AppEvent {
  final bool value;

  const ShouldShowNotificationBadge({required this.value});

  @override
  String toString() => 'ShouldShowNotificationBadge { value: $value }';
}

class ShouldShowGuardianRecoveryAlert extends AppEvent {
  final bool showGuardianRecoveryAlert;

  const ShouldShowGuardianRecoveryAlert({required this.showGuardianRecoveryAlert});

  @override
  String toString() => 'ShouldShowGuardianRecoveryAlert { value: $showGuardianRecoveryAlert }';
}

class BottomBarTapped extends AppEvent {
  final int index;

  const BottomBarTapped({required this.index});

  @override
  String toString() => 'BottomBarTapped { index: $index }';
}

class OnStopGuardianActiveRecoveryTapped extends AppEvent {
  const OnStopGuardianActiveRecoveryTapped();

  @override
  String toString() => 'OnStopGuardianActiveRecoveryTapped';
}

class OnApproveGuardianRecoveryTapped extends AppEvent {
  final GuardianRecoveryRequestData data;

  const OnApproveGuardianRecoveryTapped(this.data);

  @override
  String toString() => 'OnApproveGuardianRecoveryTapped';
}

class OnDismissGuardianRecoveryTapped extends AppEvent {
  @override
  String toString() => 'OnDismissGuardianRecoveryTapped';
}

class ClearAppPageCommand extends AppEvent {
  @override
  String toString() => 'ClearAppPageCommand';
}

class OnApproveGuardianRecoveryDeepLink extends AppEvent {
  final GuardianRecoveryRequestData data;

  const OnApproveGuardianRecoveryDeepLink(this.data);

  @override
  String toString() => 'OnApproveGuardianRecoveryDeepLink';
}

class OnSigningRequest extends AppEvent {
  final ScanESRResultData esr;

  const OnSigningRequest(this.esr);

  @override
  String toString() => 'OnSigningRequest';
}
