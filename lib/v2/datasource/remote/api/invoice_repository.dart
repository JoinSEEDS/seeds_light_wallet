import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dart_esr/dart_esr.dart' as esr;
import 'package:seeds/v2/datasource/remote/api/eos_repository.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';

class InvoiceRepository extends EosRepository {
  Future<Result<dynamic>> createInvoice(
      {required double quantity, required String accountName, required TokenModel token, String? memo}) {
    print('[ESR] create invite accountName: $accountName quantity: ($quantity)');

    final List<esr.Authorization> auth = [esr.ESRConstants.PlaceholderAuth];

    final Map<String, String> data = {
      'from': esr.ESRConstants.PlaceholderName,
      'to': accountName,
      'quantity': token.getAssetString(quantity),
      'memo': memo ?? ''
    };

    final esr.Action action = esr.Action()
      ..account = token.contract
      ..name = actionNameTransfer
      ..authorization = auth
      ..data = data;

    final esr.SigningRequestCreateArguments args = esr.SigningRequestCreateArguments(action: action, chainId: chain_id);

    return esr.SigningRequestManager.create(args,
            options: esr.defaultSigningRequestEncodingOptions(
              nodeUrl: remoteConfigurations.hyphaEndPoint,
            ))
        .then((esr.SigningRequestManager response) => ValueResult(response.encode()))
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((error) => mapEosError(error));
  }
}
