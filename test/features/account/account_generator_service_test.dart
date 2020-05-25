import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/features/account/account_generator_service.dart';

void main() {

  AccountGeneratorService _service;

  setUp(() {
    _service = AccountGeneratorService();
  });

  test('Input is complete account name', () async {
    final result = _service.generateName("111111111111");

    expect(result, "111111111111");
  });

}