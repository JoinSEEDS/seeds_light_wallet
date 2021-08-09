import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_model.dart';

class SendTransactionResponse {
  final List<Result> profiles;
  final Result transactionId;
  final TransactionModel transactionModel;

  SendTransactionResponse(this.profiles, this.transactionId, this.transactionModel);
}
