import './transactions_repository.dart';

void main() async {
  print("start");

  final repository = TransactionsListRepository();

  final transactions = await repository.getTransactions("igorberlenko");

  print("end");

  print(transactions);
}
