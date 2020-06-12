import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:seeds/features/account/account_generator_service.dart';
import 'package:seeds/providers/services/http_service.dart';

class MockHttpService extends Mock implements HttpService {}

void main() {

  HttpService httpService = MockHttpService();
  AccountGeneratorService _service;

  setUp(() {
    _service = AccountGeneratorService()..update(httpService);
  });

  group('Validate account name', () {

    test('Valid account name', () async {
      final result = _service.validate("abcdefgzhijk");

      expect(result.valid, true);
    });

    test('Valid account name', () async {
      final result = _service.validate("abcdEFGzhijk");

      expect(result.valid, false);
      expect(result.message, "Your account name should be lowercase only");
    });

    test('Numeric only account name is valid', () async {
      final result = _service.validate("123451234512");

      expect(result.valid, true);
    });

    test('Account name too short', () async {
      final result = _service.validate("abcdefgzhij");

      expect(result.valid, false);
      expect(result.message, "Your account name should have exactly 12 symbols");
    });

  });

  group('Convert suggestion to valid account name', () {

    test('Input is complete account name', () async {
      final result = _service.convert("abc123abc123");

      expect(result, "abc123abc123");
    });

    test('Input is too short', () async {
      final result = _service.convert("abc123");

      expect(result, "abc123425553");
    });

    test('With special character', () async {
      final result = _service.convert("abc12.?!#-_");

      expect(result, "abc125341554");
    });

    test('With space', () async {
      final result = _service.convert("hello world");

      expect(result, "helloworld55");
    });

    test('Input is too long', () async {
      final result = _service.convert("abc123abc12345");

      expect(result, "abc123abc123");
    });

    test('Return name if it is available', () async {
      when(httpService.isAccountNameAvailable('abc123abc123')).thenAnswer((_) async => true);

      final result = await _service.generate("abc123abc123");

      expect(result.available, "abc123abc123");
    });

    test('Modify name if it is not available', () async {
      when(httpService.isAccountNameAvailable('abcdefabcdef')).thenAnswer((_) async => false);
      when(httpService.isAccountNameAvailable('abcdefabcde1')).thenAnswer((_) async => true);

      final result = await _service.generate("abcdefabcdef");

      expect(result.available, "abcdefabcde1");
    });

    test('Generate with exclude', () async {
      when(httpService.isAccountNameAvailable('abc123abc123')).thenAnswer((_) async => true);

      final result = await _service.generate("abc123abc121", exclude: [ "abc123abc121", "abc123abc122" ]);

      expect(result.available, "abc123abc123");
    });

    test('Generate with no more to try', () async {
      when(httpService.isAccountNameAvailable('555555555551')).thenAnswer((_) async => false);

      try {
        await _service.generate("555555555551", exclude: ["555555555551", "555555555552"], recursionAttempts: 1);
        fail("Expected exception");
      } catch(error) {
        expect(error, "Couldn't find a valid account name");
      }
    });

    test('Generate a list of two account names', () async {
      when(httpService.isAccountNameAvailable('abcdefabcdef')).thenAnswer((_) async => false);
      when(httpService.isAccountNameAvailable('abcdefabcde1')).thenAnswer((_) async => true);
      when(httpService.isAccountNameAvailable('abcdefabcde2')).thenAnswer((_) async => true);

      final result = await _service.generateList("abcdefabcdef", count: 2);

      expect(result.length, 2);
      expect(result[0], "abcdefabcde1");
      expect(result[1], "abcdefabcde2");
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