import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/api/send_eos_transaction_repository.dart';
import 'package:seeds/v2/datasource/remote/model/transaction_model.dart';
import 'package:seeds/v2/screens/transfer/send/send_confirmation/interactor/viewmodels/send_transaction_response.dart';

class SendTransactionUseCase {
  final SendTransactionRepository _sendTransactionRepository = SendTransactionRepository();
  final ProfileRepository _profileRepository = ProfileRepository();
  final fromAccount = settingsStorage.accountName;

  Future<Result> run(String? toName, String account, Map<String, dynamic> data) {
    return _sendTransactionRepository.sendTransaction(toName, account, data, fromAccount).then((Result value) async {
      if (value.isError) {
        return value;
      } else {
        List<Result> profiles = await getProfileData(data['to'], fromAccount);
        var transactionModel = TransactionModel.fromTxData(data, value.asValue!.value);
        return ValueResult(SendTransactionResponse(profiles, value, transactionModel));
      }
    }).catchError((error) {
      return ErrorResult("Error Sending Transaction");
    });
  }

  Future<List<Result>> getProfileData(String toAccount, fromAccount) async {
    Future<Result> toAccountResult = _profileRepository.getProfile(toAccount);
    Future<Result> fromAccountResult = _profileRepository.getProfile(fromAccount);

    return Future.wait([toAccountResult, fromAccountResult]);
  }
}
