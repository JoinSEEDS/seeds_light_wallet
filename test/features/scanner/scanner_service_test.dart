import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/features/scanner/scanner_service.dart';

void main() {

  ScannerService _service;

  setUp(() {
    _service = ScannerService();
  });

  group('Derive content type from QR scanner data', () {

    test('Simple invite', () async {
      final result = _service.contentTypeOf("seeds-user-code-invite-words");

      expect(result, ScanContentType.inviteUrl);
    });

    test('Url invite expands into invite code promotion-copy-receiver-eating-sexuality', () async {
      final result = _service.contentTypeOf("https://seedswallet.page.link/ufUTCu7CbgQ9hSjk9");

      expect(result, ScanContentType.inviteUrl);
    });

    test('Random text with dash', () async {
      final result = _service.contentTypeOf("https://join-seeds.com");

      expect(result, ScanContentType.unknown);
    });

    test('EOSIO signing request as specified by https://github.com/eosio-eps/EEPs/blob/master/EEPS/eep-7.md', () async {
      final result = _service.contentTypeOf("esr:gmPgY2BY1mTC_MoglIGBIVzX5uxZRkYGCGCC0ooGmvN67fgn2jEwGKz9xbbCE6aAJcTHPxjEAAoAAA");

      expect(result, ScanContentType.esr);
    });

  });


}