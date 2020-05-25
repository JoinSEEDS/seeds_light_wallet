import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/features/account/account_generator_service.dart';

void main() {

  AccountGeneratorService _service;

  setUp(() {
    _service = AccountGeneratorService();
  });

  group('Validate account name', () {

    test('Valid account name', () async {
      final result = AccountGeneratorService.validate("abcdefgzhijk");

      expect(result.valid, true);
    });

    /*test('Numeric only account name is valid', () async {
      final result = AccountGeneratorService.validate("111111111111");

      expect(result.valid, true);
    });*/

    test('Account name too short', () async {
      final result = AccountGeneratorService.validate("abcdefgzhij");

      expect(result.valid, false);
      expect(result.message, "Your account name should have exactly 12 symbols");
    });

  });

  group('Generate account name', () {

    test('Input is complete account name', () async {
      final result = _service.generate("abc123abc123");

      expect(result, "abc123abc123");
    });

    /*test('Input is 1 character short of complete account name', () async {
      final result = _service.generate("abc123abc12");

      expect(result, "abc123abc121");
    });*/

  });

}