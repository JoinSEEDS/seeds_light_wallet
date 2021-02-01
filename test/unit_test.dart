import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/constants/http_mock_response.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/utils/invites.dart';
import 'package:seeds/utils/double_extension.dart';

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

  test('Find key accounts mongo', () async {

    final accounts = await HttpService().getKeyAccountsMongo("EOS8QjUzkowWLLLF4d484E2CuQz2KLUvWrHKPzsh5JzFxZcBsvcmR");

    accounts.forEach((e) => print("$e"));    
    
    expect(accounts.length > 0, true);
  });


  test('Http Service', () async {
    final service = HttpService()..update(enableMockResponse: true);

    final members = await service.getMembers();
    final transactions = await service.getTransactions();
    final balance = await service.getBalance();
    final voice = await service.getCampaignVoice();
    final proposals = await service.getProposals("active", "passed", false);
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

  test('Number formatting', () async {
    expect(0.0.seedsFormatted, "0.00");
    
    expect(0.0001.seedsFormatted, "0.0001");
    expect((-0.0001).seedsFormatted, "-0.0001");
    expect(1.0.seedsFormatted, "1.00");
    expect((-1.0).seedsFormatted, "-1.00");

    expect((3.0).seedsFormatted, "3.00");
    expect((-3.0).seedsFormatted, "-3.00");

    expect((144.0).seedsFormatted, "144.00");
    expect((7777777.0).seedsFormatted, "7,777,777.00");

  });

}