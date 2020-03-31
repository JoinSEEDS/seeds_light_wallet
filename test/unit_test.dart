import 'package:flutter_test/flutter_test.dart';
import 'package:teloswallet/constants/http_mock_response.dart';
import 'package:teloswallet/providers/services/eos_service.dart';
import 'package:teloswallet/providers/services/http_service.dart';
import 'package:teloswallet/screens/app/scan/signing_request/get_readable_request.dart';
import 'package:teloswallet/screens/app/scan/signing_request/fill_request_placeholders.dart';

void main() {
  test('Parse Signing Request', () async {
    final result = await getReadableRequest(
        'gmNgZGRkAIFXBqEFopc6760yugsVYWBggtKCMIEFRnclpF9eTWUACgAA');

    expect(result, {
      'account': 'eosio',
      'action': 'voteproducer',
      'data': {
        'voter': '............1',
        'proxy': 'greymassvote',
        'producers': []
      }
    });
  });

  test('Replace Placeholders', () async {
    final request = {
      'account': 'eosio',
      'action': 'voteproducer',
      'data': {
        'voter': 'sevenflash42',
        'proxy': 'greymassvote',
        'producers': []
      }
    };

    final result = fillRequestPlaceholders(request, 'sevenflash42');

    expect(result, {
      'account': 'eosio',
      'action': 'voteproducer',
      'data': {
        'voter': 'sevenflash42',
        'proxy': 'greymassvote',
        'producers': []
      }
    });
  });

  // test('Http Service', () async {
  //   final service = HttpService()..update(enableMockResponse: true);

  //   final transactions = await service.getTransactions();
  //   final telosBalance = await service.getTelosBalance();

  //   expect(transactions, HttpMockResponse.transactions);
  //   expect(telosBalance, HttpMockResponse.telosBalance);
  // });

  // test('Eos Service', () async {
  //   final service = EosService()..update(enableMockTransactions: true);

  //   final transferTelos = await service.transferTelos();

  //   expect(transferTelos, HttpMockResponse.transactionResult);
  // });
}
