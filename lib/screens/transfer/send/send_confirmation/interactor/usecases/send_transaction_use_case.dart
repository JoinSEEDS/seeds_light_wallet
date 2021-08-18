import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/api/send_eos_transaction_repository.dart';
import 'package:seeds/datasource/remote/model/generic_transaction_model.dart';
import 'package:seeds/datasource/remote/model/transaction_model.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_transaction_response.dart';

class SendTransactionUseCase {
  final SendTransactionRepository _sendTransactionRepository = SendTransactionRepository();
  final ProfileRepository _profileRepository = ProfileRepository();
  final fromAccount = settingsStorage.accountName;

  Future<Result> run({required String actionName, required String account, required Map<String, dynamic> data}) {
    return _sendTransactionRepository
        .sendTransaction(actionName: actionName, account: account, data: data, accountName: fromAccount)
        .then((Result value) async {
      if (value.isError) {
        return value;
      } else {
        final String transactionId = value.asValue!.value;
        final transactionModel = GenericTransactionModel(
            account: account,
            action: actionName,
            data: data,
            transactionId: transactionId,
            timestamp: DateTime.now().toUtc());
        final transferModel = TransactionModel.fromTransaction(transactionModel);
        List<Result> profiles = [];
        if (transferModel != null) {
          profiles = await getProfileData(transferModel.to, fromAccount);
        }
        return ValueResult(SendTransactionResponse(transactionModel: transactionModel, profiles: profiles));
      }
    }).catchError((error) {
      return ErrorResult("Error Sending Transaction");
    });
  }

  Future<List<Result>> getProfileData(String toAccount, fromAccount) async {
    final Future<Result> toAccountResult = _profileRepository.getProfile(toAccount);
    final Future<Result> fromAccountResult = _profileRepository.getProfile(fromAccount);
    return Future.wait([toAccountResult, fromAccountResult]);
  }
}
