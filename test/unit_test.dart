import 'package:flutter_test/flutter_test.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/constants/http_mock_response.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('HttpService Service', () async {
    final service = HttpService()..init(enableMockResponse: true);

    final members = await service.getMembers();
    final transactions = await service.getTransactions();
    final balance = await service.getBalance();
    final voice = await service.getVoice();
    final proposals = await service.getProposals("active");

    expect(members, HttpMockResponse.members);
    expect(transactions, HttpMockResponse.transactions);
    expect(balance, HttpMockResponse.balance);
    expect(voice.amount, HttpMockResponse.voice.amount);
    expect(proposals, HttpMockResponse.proposals);
  });
}
