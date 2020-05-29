import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seeds/features/account/account_generator_service.dart';
import 'package:seeds/providers/services/http_service.dart';

class MockHttpService extends Mock implements HttpService {}

void main() {

  HttpService httpService = MockHttpService();
  AccountGeneratorService _service;

  setUp(() {
    _service = AccountGeneratorService(httpService);
  });

  group('Validate account name', () {

    test('Valid account name', () async {
      final result = AccountGeneratorService.validate("abcdefgzhijk");

      expect(result.valid, true);
    });

    test('Valid account name', () async {
      final result = AccountGeneratorService.validate("abcdEFGzhijk");

      expect(result.valid, false);
      expect(result.message, "Your account name should be lowercase only");
    });

    test('Numeric only account name is valid', () async {
      final result = AccountGeneratorService.validate("123451234512");

      expect(result.valid, true);
    });

    test('Account name too short', () async {
      final result = AccountGeneratorService.validate("abcdefgzhij");

      expect(result.valid, false);
      expect(result.message, "Your account name should have exactly 12 symbols");
    });

  });

  group('Generate account name', () {

    test('Input is complete account name', () async {
      final result = AccountGeneratorService.generate("abc123abc123");

      expect(result, "abc123abc123");
    });

    test('Input is too short', () async {
      final result = AccountGeneratorService.generate("abc123");

      expect(result, "abc123425553");
    });

    test('With special character', () async {
      final result = AccountGeneratorService.generate("abc12.?!#-_");

      expect(result, "abc125341554");
    });

    test('With space', () async {
      final result = AccountGeneratorService.generate("hello world");

      expect(result, "helloworld55");
    });

    test('Input is too long', () async {
      final result = AccountGeneratorService.generate("abc123abc12345");

      expect(result, "abc123abc123");
    });

    test('Return name if it is available', () async {
      when(httpService.isAccountNameAvailable('abc123abc123')).thenAnswer((_) async => true);

      final result = await _service.generateAvailable("abc123abc123");

      expect(result, "abc123abc123");
    });

    test('Modify name if it is not available', () async {
      when(httpService.isAccountNameAvailable('abcdefabcdef')).thenAnswer((_) async => false);
      when(httpService.isAccountNameAvailable('abcdefabcde1')).thenAnswer((_) async => true);

      final result = await _service.generateAvailable("abcdefabcdef");

      expect(result, "abcdefabcde1");
    });

  });

  group('Helpful "private" methods', () {

    test('Modify account name', () async {
      final result = _service.modifyAccountName("abc123abcdef", 1);

      expect(result, "abc123abcde1");
    });

    test('Modify account name with larger number', () async {
      final result = _service.modifyAccountName("abc123abcdef", 123);

      expect(result, "abc123abc123");
    });

    test('Increase replace counter', () async {
      final result = _service.increaseReplaceCounter(1);

      expect(result, 2);
    });

    test('Bump to 11 after 5', () async {
      final result = _service.increaseReplaceCounter(5);

      expect(result, 11);
    });

    test('Bump to 21 after 15', () async {
      final result = _service.increaseReplaceCounter(15);

      expect(result, 21);
    });

    test('Bump to 34 after 33', () async {
      final result = _service.increaseReplaceCounter(33);

      expect(result, 34);
    });

    test('Bump to 51 after 45', () async {
      final result = _service.increaseReplaceCounter(45);

      expect(result, 51);
    });

    test('Bump to 111 after 55', () async {
      final result = _service.increaseReplaceCounter(55);

      expect(result, 111);
    });

    test('Bump to 1111 after 555', () async {
      final result = _service.increaseReplaceCounter(555);

      expect(result, 1111);
    });

  });


}