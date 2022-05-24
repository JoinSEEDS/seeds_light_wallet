import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/datasource/local/auth_service.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/substrate_service.dart';
import 'package:seeds/datasource/remote/api/polkadot/storage/keyring.dart';
import 'package:seeds/utils/mnemonic_code/mnemonic_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('polkadot JS', () {
    test('load JS code', () async {
      String? _jsCode;

      final service = SubstrateService();

      final keyRing = Keyring();
      await service.init(keyRing);

      // var result = await controller.evaluateJavascript(source: "1 + 1");
      // print(result.runtimeType); // int
      // print(result); // 2

      final res1 = await service.webView!.web?.webViewController.evaluateJavascript(source: '1 + 4');
      print(res1.runtimeType); // int
      print(res1);

      final res = await service.webView!.evalJavascript('1 + 1');
      print(res);

      expect(res, 2);
    });
  });
}
