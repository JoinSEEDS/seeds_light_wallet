part of 'scanner_bloc.dart';

class ScannerState extends Equatable {
  final ScanStatus scanStatus;

  const ScannerState({required this.scanStatus});

  @override
  List<Object?> get props => [scanStatus];

  bool get gotValidQR => scanStatus == ScanStatus.processing || scanStatus == ScanStatus.success;

  ScannerState copyWith({ScanStatus? scanStatus}) {
    return ScannerState(scanStatus: scanStatus ?? this.scanStatus);
  }

  factory ScannerState.initial() {
    return const ScannerState(scanStatus: ScanStatus.scan);
  }
}

enum ScanStatus { scan, processing, success }
