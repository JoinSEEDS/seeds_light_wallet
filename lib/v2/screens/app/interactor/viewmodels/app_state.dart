import 'package:equatable/equatable.dart';

/// STATE
class AppState extends Equatable {
  final int index;
  final bool hasNotification;
  final bool showGuardianRecoveryAlert;

  const AppState({required this.index, required this.hasNotification, required this.showGuardianRecoveryAlert});

  @override
  List<Object?> get props => [index, hasNotification];

  AppState copyWith({int? index, bool? hasNotification, bool? showGuardianRecoveryAlert}) {
    return AppState(
      index: index ?? this.index,
      hasNotification: hasNotification ?? this.hasNotification,
      showGuardianRecoveryAlert: showGuardianRecoveryAlert ?? this.showGuardianRecoveryAlert
    );
  }

  factory AppState.initial() {
    return const AppState(index: 0, hasNotification: false, showGuardianRecoveryAlert: false);
  }
}
