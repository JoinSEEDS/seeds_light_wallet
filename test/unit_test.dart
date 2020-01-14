import 'package:test/test.dart';
import 'package:seeds/services/http_service/http_service.dart';

void main() {
  test('Counter value should be incremented', () async {
    final service = HttpService();

    final result = await service.test();

    expect(result, 77);
  });
}
