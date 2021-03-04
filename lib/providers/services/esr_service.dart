import 'dart:typed_data';

import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:seeds/features/scanner/telos_signing_manager.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';
import 'package:eosdart/src/serialize.dart' as ser;
import 'package:dart_esr/dart_esr.dart';

class IdentityResponse {
  final String callback;
  final String body;

  IdentityResponse({
    this.callback,
    this.body,
  });
}

class EsrService {
  Future<IdentityResponse> getIdentityResponse({
    SeedsESR request,
    String accountName,
    String walletPrivateKey,
  }) async {
    var abis = await request.manager.fetchAbis();

    var signer = Authorization()
      ..actor = accountName
      ..permission = "active";

    ResolvedSigningRequest resolved = request.manager.resolve(abis, signer, null);

    var signBuf = Uint8List.fromList(
        List.from(ser.stringToHex(chainId))..addAll(resolved.serializedTransaction)..addAll(Uint8List(32)));

    var signature = EOSPrivateKey.fromString(walletPrivateKey).sign(signBuf).toString();

    var transactionId = resolved.getTransactionId().toLowerCase();
    var body = """{
                "tx": "$transactionId",
                "sig": "$signature", 
                "rbn": "${resolved.transaction.refBlockNum.toString()}",
                "rid": "${resolved.transaction.refBlockPrefix.toString()}",
                "ex": "${resolved.transaction.expiration.toString()}",
                "req": "${resolved.request.encode()}",
                "sa": "${resolved.signer.actor}",
                "sp": "${resolved.signer.permission}",
                "cid": "$chainId"
              }""";

    return IdentityResponse(
      callback: request.manager.data.callback,
      body: body,
    );
  }

  Future<CustomTransactionArguments> getTransactionArguments({
    SeedsESR request,
    String accountName,
  }) async {
    await request.resolve(account: accountName);

    var action = request.actions.first;

    var data = Map<String, dynamic>.from(action.data);

    var arguments = CustomTransactionArguments(
      account: action.account,
      name: action.name,
      data: data,
    );

    return arguments;
  }
}
