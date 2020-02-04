import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/constants/http_mock_response.dart';
import 'package:seeds/utils/invites.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Convert invite hash', () async {
    String input = "8669574470f134c4d95c284d9f397f6c48a6db8ea44830d8e433574836ff007e";
    String expectedOutput = '6c7f399f4d285cd9c434f170445769867e00ff36485733e4d83048a48edba648';

    String output = reverseHash(input);

    expect(expectedOutput, output);
  });
  test('Invite Integration', () async {
    final service = HttpService()
      ..update(
        enableMockResponse: false,
        nodeEndpoint: 'https://telos.caleos.io',
      );

    final invites = await service.getInvites();

    print(invites);
  });

  test('Http Service', () async {
    final service = HttpService()..update(enableMockResponse: true);

    final members = await service.getMembers();
    final transactions = await service.getTransactions();
    final balance = await service.getBalance();
    final voice = await service.getVoice();
    final proposals = await service.getProposals("active");
    final invites = await service.getInvites();

    expect(members, HttpMockResponse.members);
    expect(transactions, HttpMockResponse.transactions);
    expect(balance, HttpMockResponse.balance);
    expect(voice.amount, HttpMockResponse.voice.amount);
    expect(proposals, HttpMockResponse.proposals);
    expect(invites, HttpMockResponse.invites);
  });

  test('Eos Service', () async {
    final service = EosService()..update(enableMockTransactions: true);

    final createInvite = await service.createInvite();
    final acceptInvite = await service.acceptInvite();
    final transferSeeds = await service.transferSeeds();
    final voteProposal = await service.voteProposal();

    expect(createInvite, HttpMockResponse.transactionResult);
    expect(acceptInvite, HttpMockResponse.transactionResult);
    expect(transferSeeds, HttpMockResponse.transactionResult);
    expect(voteProposal, HttpMockResponse.transactionResult);
  });
}

// I/flutter ( 3715): invite mnemonic: musician-layer-faith-jump-decision
// I/flutter ( 3715): invite secret: 59f703fe1e94a07d08c31cc63996e864342b9af034a9b4a00c5946037b7cf4c6
// I/flutter ( 3715): invite hash: 5a1c8afc4aa6b001e9f36d4f1fe1997ef93bcbaec551ed9bd03be3c166913ccb
