
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/features/scanner/scanner_service.dart';
import 'package:seeds/utils/bloc/cmd_common.dart';

abstract class ScannerCmd extends Cmd {}
class StartScannerCmd extends ScannerCmd {}
class UpdateTextCmd extends ScannerCmd {
  final TextEditingController textController;
  final String text;
  UpdateTextCmd(this.textController, this.text);
}

class ScannerBloc {

  ScannerService _scannerService;
  final _scanResult = BehaviorSubject<ScanResult>();
  final _execute = PublishSubject<ScannerCmd>();
  final _textController = BehaviorSubject<TextEditingController>();

  Stream<String> get data => _scanResult.stream
    .where((result) => _scannerService.statusFromResult(result) == ScanStatus.cancelled)
    .map((result) => "${DateTime.now().millisecondsSinceEpoch}_result.rawContent");
  Stream<ScanStatus> get status => _scanResult.stream.map(_scannerService.statusFromResult);
  Function(ScannerCmd) get execute => _execute.add;
  Function(TextEditingController) get setTextController => _textController.add;

  ScannerBloc() {
    _execute.listen(_executeCommand);
    _initScanResult();
  }

  void update(ScannerService scannerService) {
    this._scannerService = scannerService;
  }

  void _initScanResult() {
    CombineLatestStream
      .combine2(_textController, data, (controller, text) => UpdateTextCmd(controller, text))
      .listen(execute);
  }

  _executeCommand(ScannerCmd cmd) {
    switch(cmd.runtimeType) {
      case StartScannerCmd:
        return _startScanner();

      case UpdateTextCmd:
        return _updateText(cmd as UpdateTextCmd);

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

  _updateText(UpdateTextCmd cmd) {
    cmd.textController.text = cmd.text;
  }

  void discard() {
    _scanResult.close();
    _execute.close();
    _textController.close();
  }

}
