
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/features/scanner/scanner_service.dart';
import 'package:seeds/providers/services/permission_service.dart';
import 'package:seeds/utils/bloc/cmd_common.dart';

abstract class ScannerCmd extends Cmd {}
class QueryCameraPermissionCmd extends ScannerCmd {}
class RequestCameraPermissionCmd extends ScannerCmd {}
class OpenSettingsCmd extends ScannerCmd {}
class StartScannerCmd extends ScannerCmd {}
class UpdateTextCmd extends ScannerCmd {
  final TextEditingController textController;
  final String text;
  UpdateTextCmd(this.textController, this.text);
}
class SetTextControllerCmd extends ScannerCmd {
  final TextEditingController textController;
  final ScanContentType updateOnType;
  SetTextControllerCmd(this.textController, this.updateOnType);

  @override
  bool operator ==(Object other) => identical(this, other) ||
    other is SetTextControllerCmd &&
    runtimeType == other.runtimeType &&
    textController == other.textController &&
    updateOnType == other.updateOnType;

  @override int get hashCode => textController.hashCode ^ updateOnType.hashCode;
}

class ScannerBloc {

  ScannerService _scannerService;
  PermissionService _permissionService;
  final _available = BehaviorSubject<ScannerAvailable>();
  final _scanResult = BehaviorSubject<ScanResult>();
  final _status = BehaviorSubject<ScanStatus>();
  final _execute = PublishSubject<ScannerCmd>();
  final _textController = BehaviorSubject<SetTextControllerCmd>();
  final _inviteCode = BehaviorSubject<String>();

  Stream<ScannerAvailable> get available => _available.stream;
  Stream<ScannedData> get data => _scanResult.stream
    .where((result) => _scannerService.statusFromResult(result) == ScanStatus.successful)
    .map((result) => ScannedData(result.rawContent, _scannerService.contentTypeOf(result.rawContent)));
  Stream<ScanStatus> get status => _scanResult.stream.map(_scannerService.statusFromResult);
  Stream<String> get inviteCode => _inviteCode.stream;
  Stream<SetTextControllerCmd> get textController => _textController.stream.distinct();
  Function(ScannerCmd) get execute => _execute.add;

  ScannerBloc() {
    _execute.listen(_executeCommand);
    _initScanResultStatus();
    _initUpdateTextController();
    _initInviteCode();
  }

  void update(ScannerService scannerService, PermissionService permissionService) {
    this._scannerService = scannerService;
    this._permissionService = permissionService;
  }

  void _initScanResultStatus() {
    _scanResult.stream
      .map((scanResult) => _scannerService.statusFromResult(scanResult))
      .listen(_status.add);
  }

  void _initUpdateTextController() {
    CombineLatestStream
      .combine2(_textController.distinct(), inviteCode, (SetTextControllerCmd ctrl, code) {
        return ctrl.updateOnType == ScanContentType.inviteCode ? UpdateTextCmd(ctrl.textController, code) : null;
      }).where((cmd) => cmd != null)
      .listen(execute);
  }
  
  void _initInviteCode() {
    data
      .where((data) => data.type == ScanContentType.inviteUrl)
      .flatMap((data) => _scannerService.decodeInviteUrl(data.data))
      .map((uri) => uri.queryParameters["inviteMnemonic"])
      .listen(_inviteCode.add);

    data
      .where((data) => data.type == ScanContentType.inviteCode)
      .map((data) => data.data)
      .listen(_inviteCode.add);
  }

  _executeCommand(ScannerCmd cmd) {
    switch(cmd.runtimeType) {
      case QueryCameraPermissionCmd:
        return _cameraPermission(true);

      case RequestCameraPermissionCmd:
        return _cameraPermission(false);

      case OpenSettingsCmd:
        return _permissionService.openSettings();

      case StartScannerCmd:
        return _startScanner();

      case UpdateTextCmd:
        return _updateText(cmd as UpdateTextCmd);
        
      case SetTextControllerCmd:
        return _textController.add(cmd as SetTextControllerCmd);

      default:
        throw UnknownCmd(cmd);
    }
  }

  void _cameraPermission(bool query) {
    _permissionService
      .camera(query)
      .asStream()
      .map(_convertPermissionStatus)
      .listen(_available.add);
  }

  ScannerAvailable _convertPermissionStatus(PermissionStatus permissionStatus) {
    switch(permissionStatus) {
      case PermissionStatus.granted:
        return ScannerAvailable.available;
        
      case PermissionStatus.undetermined:
        return ScannerAvailable.permissionRequired;

      default:
        return ScannerAvailable.unavailable;
    }  
  }

  void _startScanner() {
    _scannerService
      .start()
      .asStream()
      .listen(_scanResult.add)
      .onError((error) {
        print("Camera error: $error");
        execute(QueryCameraPermissionCmd());
      });
  }

  _updateText(UpdateTextCmd cmd) {
    cmd.textController.text = cmd.text;
  }

  void discard() {
    _available.close();
    _scanResult.close();
    _status.close();
    _execute.close();
    _textController.close();
    _inviteCode.close();
  }

}

class ScannedData {
  final String data;
  final ScanContentType type;
  ScannedData(this.data, this.type);
}

enum ScannerAvailable {
  unknown,
  available,
  unavailable,
  permissionRequired,
}

extension ScannerAvailableExt on ScannerAvailable {
  bool get isScanButtonVisible => [
    ScannerAvailable.unknown,
    ScannerAvailable.available,
    ScannerAvailable.permissionRequired,
  ].contains(this);
}