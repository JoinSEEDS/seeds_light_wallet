import 'dart:async';
import 'dart:convert';

import 'package:seeds/datasource/remote/api/polkadot/api/polkawallet_api.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/txInfoData.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/tx.dart';

class ApiTx {
  ApiTx(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceTx service;

  /// Estimate tx fees, [params] will be ignored if we have [rawParam].
  Future<TxFeeEstimateResult> estimateFees(TxInfoData txInfo, List params,
      {String? rawParam, String? jsApi}) async {
    final String param = rawParam ?? jsonEncode(params);
    final Map tx = txInfo.toJson();
    final res = await (service.estimateFees(tx, param, jsApi: jsApi)
        as FutureOr<Map<dynamic, dynamic>>);
    return TxFeeEstimateResult.fromJson(res as Map<String, dynamic>);
  }

//  Future<dynamic> _testSendTx() async {
//    Completer c = new Completer();
//    void onComplete(res) {
//      c.complete(res);
//    }
//
//    Timer(Duration(seconds: 6), () => onComplete({'hash': '0x79867'}));
//    return c.future;
//  }

  /// Send tx, [params] will be ignored if we have [rawParam].
  /// [onStatusChange] is a callback when tx status change.
  /// @return txHash [string] if tx finalized success.
  Future<Map> signAndSend(
    TxInfoData txInfo,
    List params,
    String password, {
    Function(String)? onStatusChange,
    String? rawParam,
  }) async {
    final param = rawParam ?? jsonEncode(params);
    final Map tx = txInfo.toJson();
    print(tx);
    print(param);
    final res = await (service.signAndSend(
      tx,
      param,
      password,
      onStatusChange ?? (status) => print(status),
    ) as FutureOr<Map<dynamic, dynamic>>);
    if (res['error'] != null) {
      throw Exception(res['error']);
    }
    return res;
  }
}
