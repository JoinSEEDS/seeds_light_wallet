
import 'package:barcode_scan/barcode_scan.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/features/scanner/scanner_service.dart';
import 'package:seeds/utils/bloc/cmd_common.dart';

abstract class ScannerCmd extends Cmd {}
class StartScannerCmd extends ScannerCmd {}

class ScannerBloc {

  ScannerService _scannerService;
  final _scanResult = BehaviorSubject<ScanResult>();
  final _execute = PublishSubject<ScannerCmd>();

  Stream<String> get data => _scanResult.stream.map((result) => result.rawContent);
  Stream<ScanStatus> get status => _scanResult.stream.map(_scannerService.statusFromResult);
  Function(ScannerCmd) get execute => _execute.add;

  ScannerBloc() {
    _execute.listen(_executeCommand);
    _initScanResult();
  }

  void update(ScannerService scannerService) {
    this._scannerService = scannerService;
  }

  void _initScanResult() {

  }

  _executeCommand(ScannerCmd cmd) {
    switch(cmd.runtimeType) {
      case StartScannerCmd:
        return _startScanner();

      default:
        throw UnknownCmd(cmd);
    }
  }

  void _startScanner() {
    _scannerService
      .start()
      .asStream()
      .listen(_scanResult.add);
  }

  void discard() {
    _scanResult.close();
    _execute.close();
  }

}
