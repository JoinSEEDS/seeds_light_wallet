import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/constants/http_mock_response.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Http Service', () async {
    final service = HttpService()..update(enableMockResponse: true);

    final members = await service.getMembers();
    final transactions = await service.getTransactions();
    final balance = await service.getBalance();
    final voice = await service.getVoice();
    final proposals = await service.getProposals("active");
    final invites = await service.getInvites();
    final exchange = await service.getExchangeConfig();
    final telosBalance = await service.getTelosBalance();

    expect(members, HttpMockResponse.members);
    expect(transactions, HttpMockResponse.transactions);
    expect(balance, HttpMockResponse.balance);
    expect(voice.amount, HttpMockResponse.voice.amount);
    expect(proposals, HttpMockResponse.proposals);
    expect(invites, HttpMockResponse.invites);
    expect(exchange, HttpMockResponse.exchangeConfig);
    expect(telosBalance, HttpMockResponse.telosBalance);
  });

  test('Eos Service', () async {
    final service = EosService()..update(enableMockTransactions: true);

    final createInvite = await service.createInvite();
    final acceptInvite = await service.acceptInvite();
    final transferSeeds = await service.transferSeeds();
    final voteProposal = await service.voteProposal();
    final transferTelos = await service.transferTelos();

    expect(createInvite, HttpMockResponse.transactionResult);
    expect(acceptInvite, HttpMockResponse.transactionResult);
    expect(transferSeeds, HttpMockResponse.transactionResult);
    expect(voteProposal, HttpMockResponse.transactionResult);
    expect(transferTelos, HttpMockResponse.transactionResult);
  });
}
