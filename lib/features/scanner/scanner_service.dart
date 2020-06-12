import 'package:barcode_scan/barcode_scan.dart';

enum ScanStatus {
  successful,
  cancelled,
  failed
}

class ScannerService {

  void test() async {
    final opt = ScanOptions(

    );
    var result = await BarcodeScanner.scan(options: opt);

    print(result.type); // The result type (barcode, cancelled, failed)
    print(result.rawContent); // The barcode content
    print(result.format); // The barcode format (as enum)
    print(result.formatNote); // If a unknown format was scanned this field contains a note
  }

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

}