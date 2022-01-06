part of 'send_scanner_bloc.dart';

abstract class SendScannerEvent extends Equatable {
  const SendScannerEvent();

  @override
  List<Object?> get props => [];
}

class ExecuteScanResult extends SendScannerEvent {
  final String scanResult;

  const ExecuteScanResult(this.scanResult);

  @override
  String toString() => 'ExecuteScanResult: { scanResult: $scanResult }';
}

class ClearSendScannerPageCommand extends SendScannerEvent {
  const ClearSendScannerPageCommand();

  @override
  String toString() => 'ClearSendScannerPageCommand';
}
