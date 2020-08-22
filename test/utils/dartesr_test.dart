import 'package:eosdart/eosdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartesr/eosio_signing_request.dart';

void main() {
  group('dartesr', () {
    test('decode esr', () async {
      final client =
          EOSClient('https://telos.caleos.io', 'v1', privateKeys: []);

      final esr = await EosioSigningRequest.factory(
        client,
        'esr:gmNgYmAoCOJqXqlwloGBIVzX5uxZRkYGCGCC0oowAYeHIR9XFWsWFwhCRFiCXV1dgoEMIBcA',
        'sevenflash42',
      );

      Map<String, dynamic> data = Map<String, dynamic>.from(esr.action.data);

      expect(esr.action.account, 'token.seeds');
      expect(esr.action.name, 'transfer');
      expect(data['from'], 'sevenflash42');
      expect(data['to'], 'igorberlenko');
      expect(data['quantity'], '7.0000 SEEDS');
      expect(data['memo'], '');
    });
    test('login signing', () async {
      final client =
          EOSClient('https://telos.caleos.io', 'v1', privateKeys: []);

      final esr = await EosioSigningRequest.factory(
        client,
        'esr:AgACAwACO2h0dHBzOi8vY2IuYW5jaG9yLmxpbmsvODE3NzNjYWUtYjUzZS00YTdmLTg2ZjctNzJmOTQzZjhiYTk3AQRsaW5rKgAIAAAA06oHAAKLu05xjZ9d38TXa0W9f_WH76gGXk4wxIzEw31kEpVMQg',
        'illumination',
      );

      expect(esr.action.name, 'identity');
    });
  });
}
