import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/model/custom_transaction_model.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_model.dart';

class TransferData {}

class SendTransactionResponse {
  final CustomTransactionModel transactionModel;
  final List<Result>? profiles;

  bool get isTransfer => TransactionModel.fromTransaction(transactionModel) != null;
  TransactionModel? get transferTransactionModel => TransactionModel.fromTransaction(transactionModel);
  ProfileModel? get parseToUser => profiles?[0].asValue?.value as ProfileModel?;
  ProfileModel? get parseFromUser => profiles?[1].asValue?.value as ProfileModel?;

  SendTransactionResponse({required this.transactionModel, this.profiles});
}
