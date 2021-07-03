import './transactions_repository.dart';

void main() async {
  print("start");

  final repository = TransactionsRepository();

  final transactions = await repository.getTransactions("igorberlenko");

  print("end");

  print(transactions);
}
