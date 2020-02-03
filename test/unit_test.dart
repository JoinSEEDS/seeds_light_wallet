import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/constants/http_mock_response.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
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
