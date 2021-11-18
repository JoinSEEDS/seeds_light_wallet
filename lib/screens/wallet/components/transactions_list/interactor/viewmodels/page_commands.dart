import 'package:seeds/datasource/remote/model/transaction_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

class ShowTransactionDetails extends PageCommand {
  final TransactionModel transaction;
  ShowTransactionDetails(this.transaction);
}
