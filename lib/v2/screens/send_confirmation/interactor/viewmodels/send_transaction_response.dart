import 'package:async/async.dart';

class SendTransactionResponse {
  final List<Result> profiles;
  final Result transactionId;

  SendTransactionResponse(this.profiles, this.transactionId);
}
