import 'package:async/async.dart';

import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/datasource/remote/api/eos_repo/eos_repository.dart';
import 'package:seeds/datasource/remote/api/eos_repo/seeds_eos_actions.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/domain-shared/app_constants.dart';

class InvoiceRepository extends EosRepository {
  Future<Result<String>> createInvoice(
      {required TokenDataModel tokenAmount, required String accountName, required String tokenContract, String? memo}) {
    print('[ESR] create invite accountName: $accountName quantity: ${tokenAmount.asFormattedString()}');

    final List<esr.Authorization> auth = [esr.ESRConstants.PlaceholderAuth];

    final Map<String, String> data = {
      'from': esr.ESRConstants.PlaceholderName,
      'to': accountName,
      'quantity': TokenModel.getAssetString(tokenAmount.id, tokenAmount.amount),
      'memo': memo ?? ''
    };

    final esr.Action action = esr.Action()
      ..account = tokenContract
      ..name = SeedsEosAction.actionNameTransfer.value
      ..authorization = auth
      ..data = data;

    final esr.SigningRequestCreateArguments args = esr.SigningRequestCreateArguments(action: action, chainId: chainId);

    return esr.SigningRequestManager.create(args,
            options: esr.defaultSigningRequestEncodingOptions(
              nodeUrl: remoteConfigurations.hyphaEndPoint,
            ))
        .then((esr.SigningRequestManager response) => ValueResult(response.encode()))
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((error) => mapEosError(error));
  }
}
