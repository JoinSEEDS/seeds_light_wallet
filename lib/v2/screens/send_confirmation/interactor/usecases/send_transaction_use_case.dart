import 'package:async/async.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/profile_repository.dart';
import 'package:seeds/v2/datasource/remote/api/send_eos_transaction_repository.dart';
import 'package:seeds/v2/datasource/remote/model/fiat_rate_model.dart';

export 'package:async/src/result/result.dart';

class SendTransactionUseCase {
  final SendTransactionRepository _sendTransactionRepository = SendTransactionRepository();
  final ProfileRepository _profileRepository = ProfileRepository();
  final fromAccount = settingsStorage.accountName;

  Future<Result> run(String toName, String account, Map<String, dynamic> data, FiatRateModel rates) {
    return _sendTransactionRepository.sendTransaction(toName, account, data, fromAccount).then((Result value) async {
      if (value.isError) {
        return value;
      } else {
        List<Result> profiles = await getProfileData(data["to"], fromAccount);


        GERY HERE!!

        var selectedFiat = settingsStorage.selectedFiatCurrency;
        var actualRate = rates.rates[selectedFiat];



        return ValueResult(SendTransactionResponse(profiles, value));
      }
    }).catchError((onError) => () {
          return ErrorResult(onError);
        });
  }

  Future<List<Result>> getProfileData(String toAccount, fromAccount) async {
    Future<Result> toAccountResult = _profileRepository.getProfile(toAccount);
    Future<Result> fromAccountResult = _profileRepository.getProfile(fromAccount);

    return await Future.wait([toAccountResult, fromAccountResult]);
  }
}

class SendTransactionResponse {
  final List<Result> profiles;
  final Result transactionId;

  SendTransactionResponse(this.profiles, this.transactionId);
}
