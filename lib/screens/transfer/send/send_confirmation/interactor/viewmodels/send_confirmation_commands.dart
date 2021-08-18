import 'package:seeds/datasource/remote/model/generic_transaction_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/transaction_model.dart';
import 'package:seeds/domain-shared/page_command.dart';

abstract class TransactionPageCommand extends PageCommand {}

class ShowTransactionSuccess extends TransactionPageCommand {
  final GenericTransactionModel transactionModel;

  ShowTransactionSuccess({
    required this.transactionModel,
  });
}

class ShowTransferSuccess extends TransactionPageCommand {
  final TransactionModel transactionModel;
  ProfileModel? from;
  ProfileModel? to;
  double quantity;
  double fiatQuantity;

  ShowTransferSuccess({
    required this.transactionModel,
    this.from,
    this.to,
    required this.quantity,
    required this.fiatQuantity,
  });
}
