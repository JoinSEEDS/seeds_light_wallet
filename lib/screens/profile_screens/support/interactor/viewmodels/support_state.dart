part of 'support_bloc.dart';

class SupportState extends Equatable {
  final String? firebaseInstallationId;
  final String? appName;
  final String? version;
  final String? buildNumber;

  const SupportState({
    this.firebaseInstallationId,
    this.appName,
    this.version,
    this.buildNumber,
  });

  @override
  List<Object?> get props => [
        firebaseInstallationId,
        appName,
        version,
        buildNumber,
      ];

  SupportState copyWith({
    String? firebaseInstallationId,
    String? appName,
    String? version,
    String? buildNumber,
  }) {
    return SupportState(
      version: version ?? this.version,
      firebaseInstallationId: firebaseInstallationId ?? this.firebaseInstallationId,
      appName: appName ?? this.appName,
      buildNumber: buildNumber ?? this.buildNumber,
    );
  }

  factory SupportState.initial() {
    return const SupportState();
  }
}
