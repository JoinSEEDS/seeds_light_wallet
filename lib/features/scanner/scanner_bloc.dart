
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/features/scanner/esr_service.dart';
import 'package:seeds/features/scanner/scanner_service.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/permission_service.dart';
import 'package:seeds/utils/bloc/cmd_common.dart';

abstract class ScannerCmd extends Cmd {}
class QueryCameraPermissionCmd extends ScannerCmd {}
class RequestCameraPermissionCmd extends ScannerCmd {}
class OpenSettingsCmd extends ScannerCmd {}
class StartScannerCmd extends ScannerCmd {}

class ScannerBloc {

  ScannerService _scannerService;
  PermissionService _permissionService;
  EsrService _esrService;
  final _available = BehaviorSubject<ScannerAvailable>();
  final _scanResult = BehaviorSubject<ScanResult>();
  final _status = BehaviorSubject<ScanStatus>();
  final _execute = PublishSubject<ScannerCmd>();
  final _inviteCode = BehaviorSubject<String>();
  final _esrData = BehaviorSubject<String>();

  Stream<ScannerAvailable> get available => _available.stream;
  Stream<ScannedData> get data => _scanResult.stream
    .where((result) => _scannerService.statusFromResult(result) == ScanStatus.successful)
    .map((result) => ScannedData(result.rawContent, _scannerService.contentTypeOf(result.rawContent)));
  Stream<ScanStatus> get status => _scanResult.stream.map(_scannerService.statusFromResult);
  Stream<String> get inviteCode => _inviteCode.stream;
  Stream<String> get esrData => _esrData.stream;
  Function(ScannerCmd) get execute => _execute.add;

  ScannerBloc() {
    _execute.listen(_executeCommand);
    _initScanResultStatus();
    _initInviteCode();
    _initEsr();
  }

  void update({ ScannerService scannerService, PermissionService permissionService, EsrService esrService, SettingsNotifier settings }) {
    this._scannerService = scannerService;
    this._permissionService = permissionService;
    this._esrService = esrService;
    //this._settings = settings;
  }

  void _initScanResultStatus() {
    _scanResult.stream
      .map((scanResult) => _scannerService.statusFromResult(scanResult))
      .listen(_status.add);
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

  void _initEsr() {
    data
      .where((scanned) => scanned.type == ScanContentType.esr)
      //.flatMap((scanned) => _esrService.test(scanned.data, _settings.accountName))
      .listen((scanned) {
        _esrService.test("esr:gmN0S9_Eeqy57zv_9xn9eU3hL_bxCbUs-jptJqsXY3-JtawgEwMKYGQoCOJqXqlwFsgO17U5e5axYXLQjtTjk9eAZFe8NTJShQkcWGe1cabK-lUL2hjBWlmCXV1dgoF0SWpxCQOTdUZJSUGxlb5-cpJeYl5yRn6RXk5mXra-ZUpKSmqymYWuUWpqmq6JhZmxbpJxmoFuSqqpOVDKyNLSyIiRuyi1pLQoL74gsSRDH2ZQSWpOfrFeUk5-drFeZr5-eWJOTmqJfklRYl5xWmqRsqdTlGdhZIErAA", "pmdwithseeds");
        //_esrService.test("esr:gmPgY2BY1mTC_MoglIGBIVzX5uxZRkYGCGCC0ooGmvN67fgn2jEwGKz9xbbCE6aAJcTHPxjEAAoAAA", "buckyjohnso1");
        //_esrService.test(scanned.data, _settings.accountName);
        debugPrint("ESR $scanned");
      });
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

  void discard() {
    _available.close();
    _scanResult.close();
    _status.close();
    _execute.close();
    _inviteCode.close();
    _esrData.close();
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