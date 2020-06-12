import 'package:barcode_scan/barcode_scan.dart';

enum ScanStatus {
  successful,
  cancelled,
  failed
}

enum ScanContentType {
  invite,
  esr, // EOSIO signing request; https://github.com/eosio-eps/EEPs/blob/master/EEPS/eep-7.md
  guardian,
  unknown,
}

class ScannerService {
  
  Future<ScanResult> start() {
    return BarcodeScanner.scan();
  }

  ScanStatus statusFromResult(ScanResult result) {
    switch(result.type) {
      case ResultType.Barcode:
        return ScanStatus.successful;

      case ResultType.Cancelled:
        return ScanStatus.cancelled;

      case ResultType.Error:
      default:
        return ScanStatus.failed;
    }
  }

  ScanContentType contentTypeOf(String content) {
    if(content == null) {
      return ScanContentType.unknown;
    } else if(content.startsWith("esr:")) {
      return ScanContentType.esr;
    } else if(content.contains("-")) {
      final words = content.split("-");
      if(words.length >= 5) {
        return ScanContentType.invite;
      }
    }

    return ScanContentType.unknown;
  }

}