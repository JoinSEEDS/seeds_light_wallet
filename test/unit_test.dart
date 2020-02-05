import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/constants/http_mock_response.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/utils/invites.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('hash from secret', () async {
    String input = 'efb35624d5623b1973f5379d6a5c1c5d05e24f0027e5d18f6d0628a2814d3226';
    String expectedOutput = '8dd7882c9509452f2cd769ffed67b17af2435f4c36f342f1b1924fc406d37063';

    String output = hashFromSecret(input);

    expect(output, expectedOutput);
  });

  test('secret from mnemonic', () async {
    String input = "59f703fe1e94a07d08c31cc63996e864342b9af034a9b4a00c5946037b7cf4c6";
    String expectedOutput = "efb35624d5623b1973f5379d6a5c1c5d05e24f0027e5d18f6d0628a2814d3226";

    String output = secretFromMnemonic(input);

    expect(output, expectedOutput);
  });
  test('reverse hash', () async {
    String input = "e45e36a13b9c90b053f08097d962a6a27b753416264efb345781f4e064f406f4";
    String expectedOutput = '6c7f399f4d285cd9c434f170445769867e00ff36485733e4d83048a48edba648';

    String output = reverseHash(input);

    expect(output, expectedOutput);
  });
  test('Invite Integration', () async {
    final service = HttpService()
      ..update(
        enableMockResponse: false,
        nodeEndpoint: 'https://telos.caleos.io',
      );

    final invites = await service.getInvites();

    expect(invites.length > 0, true);
  });

  test('Http Service', () async {
    final service = HttpService()..update(enableMockResponse: true);

    final members = await service.getMembers();
    final transactions = await service.getTransactions();
    final balance = await service.getBalance();
    final voice = await service.getVoice();
    final proposals = await service.getProposals("active");
    final invites = await service.getInvites();
    final profile = await service.getProfile();

    expect(members, HttpMockResponse.members);
    expect(transactions, HttpMockResponse.transactions);
    expect(balance, HttpMockResponse.balance);
    expect(voice.amount, HttpMockResponse.voice.amount);
    expect(proposals, HttpMockResponse.proposals);
    expect(invites, HttpMockResponse.invites);
    expect(profile, HttpMockResponse.profile);
  });

  test('Eos Service', () async {
    final service = EosService()..update(enableMockTransactions: true);

    final createInvite = await service.createInvite();
    final acceptInvite = await service.acceptInvite();
    final transferSeeds = await service.transferSeeds();
    final voteProposal = await service.voteProposal();
    final updateProfile = await service.updateProfile();

    expect(createInvite, HttpMockResponse.transactionResult);
    expect(acceptInvite, HttpMockResponse.transactionResult);
    expect(transferSeeds, HttpMockResponse.transactionResult);
    expect(voteProposal, HttpMockResponse.transactionResult);
    expect(updateProfile, HttpMockResponse.transactionResult);
  });
}