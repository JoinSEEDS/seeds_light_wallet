import 'package:equatable/equatable.dart';

enum ScanStatus { scan, processing, success, stop }

class ScannerState extends Equatable {
  final ScanStatus scanStatus;

  const ScannerState({required this.scanStatus});

  @override
  List<Object> get props => [scanStatus];

  ScannerState copyWith({ScanStatus? scanStatus}) {
    return ScannerState(
      scanStatus: scanStatus ?? this.scanStatus,
    );
  }

  factory ScannerState.initial() {
    return const ScannerState(scanStatus: ScanStatus.scan);
  }
}
