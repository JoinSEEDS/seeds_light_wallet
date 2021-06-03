// ignore: import_of_legacy_library_into_null_safe
import 'package:dart_esr/dart_esr.dart' as esr;
import 'package:seeds/v2/datasource/remote/api/eos_repository.dart';
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';
import 'package:async/async.dart';

class InviteRepository extends NetworkRepository with EosRepository {
  Future<Result> createInvoice({
    required double quantity,
    required String accountName,
    String? memo,
  }) async {
    print('[eos] create invite $accountName ($quantity)');

    var auth = [esr.ESRConstants.PlaceholderAuth];

    var data = {
      'from': esr.ESRConstants.PlaceholderName,
      'to': accountName,
      'quantity': '${quantity.toStringAsFixed(4)}',
      'memo': memo ?? ''
    };

    var action = esr.Action()
      ..account = 'token.seeds'
      ..name = 'transfer'
      ..authorization = auth
      ..data = data;

    var args = esr.SigningRequestCreateArguments(action: action, chainId: chainId);

    var request = await esr.SigningRequestManager.create(args,
        options: esr.defaultSigningRequestEncodingOptions(
          nodeUrl: remoteConfigurations.hyphaEndPoint,
        ));

    var result = request.encode();

    return ValueResult(result);
  }
}
