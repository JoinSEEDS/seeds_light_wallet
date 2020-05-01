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
    String input = "senator-gender-pole-campus-electronics";
    String expectedOutput = "acc8468f23dbd4dadb54d20556a454338d0d9fa0fd758137d9f0bb5953e32690";

    String output = secretFromMnemonic(input);

    expect(output, expectedOutput);
  });
  test('reverse hash', () async {
    String input = "e45e36a13b9c90b053f08097d962a6a27b753416264efb345781f4e064f406f4";
    String expectedOutput = 'a2a662d99780f053b0909c3ba1365ee4f406f464e0f4815734fb4e261634757b';

    String output = reverseHash(input);

    expect(output, expectedOutput);
  });
  test('Invite Integration', () async {
    final service = HttpService()
      ..update(
        accountName: 'testingseeds',
        enableMockResponse: true,
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
    final harvest = await service.getHarvest();
    final score = await service.getScore();
    final exchange = await service.getExchangeConfig();
    final telosBalance = await service.getTelosBalance();

    expect(members, HttpMockResponse.members);
    expect(transactions, HttpMockResponse.transactions);
    expect(balance, HttpMockResponse.balance);
    expect(voice.amount, HttpMockResponse.voice.amount);
    expect(proposals, HttpMockResponse.proposals);
    expect(invites, HttpMockResponse.invites);
    expect(profile, HttpMockResponse.profile);
    expect(harvest, HttpMockResponse.harvest);
    expect(score, HttpMockResponse.score);
    expect(exchange, HttpMockResponse.exchangeConfig);
    expect(telosBalance, HttpMockResponse.telosBalance);
  });

  test('Eos Service', () async {
    final service = EosService()..update(enableMockTransactions: true);

    final createInvite = await service.createInvite(quantity: 10.0);
    final acceptInvite = await service.acceptInvite();
    final transferSeeds = await service.transferSeeds();
    final voteProposal = await service.voteProposal();
    final updateProfile = await service.updateProfile();
    final plantSeeds = await service.plantSeeds();
    final transferTelos = await service.transferTelos();

    expect(createInvite, HttpMockResponse.transactionResult);
    expect(acceptInvite, HttpMockResponse.transactionResult);
    expect(transferSeeds, HttpMockResponse.transactionResult);
    expect(voteProposal, HttpMockResponse.transactionResult);
    expect(updateProfile, HttpMockResponse.transactionResult);
    expect(plantSeeds, HttpMockResponse.transactionResult);
    expect(transferTelos, HttpMockResponse.transactionResult);
  });
}