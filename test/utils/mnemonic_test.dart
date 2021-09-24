import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/domain-shared/shared_use_cases/recovery_phrase_use_case.dart';

void main() {
  group('mnemonic', () {
    test('mnemonic test', () async {
      final hex = "0000000000000000000000000000000000000000000000000000000000000000";
      final base58key = '5HpHagT65TZzG1PH3CSu63k8DbpvD8s5ip4nEB3kEsreAbuatmU';

      RecoveryPhraseUseCase().run();
    });
  });
}
