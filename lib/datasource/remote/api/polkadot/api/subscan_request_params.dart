import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

const int txListPageSize = 10;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class SubScanRequestParams {
  SubScanRequestParams({
    this.sendPort,
    this.network,
    this.address,
    this.page,
    this.row,
    this.module,
    this.call,
  });

  /// exec in isolate with a message send port
  SendPort? sendPort;

  String? network;
  String? address;
  int? page;
  int? row;
  String? module;
  String? call;
}

// ignore: constant_identifier_names
const post_headers = {"Content-type": "application/json", "Accept": "*/*"};

/// Querying txs from [subscan.io](https://subscan.io).
class SubScanApi {
  final String moduleBalances = 'Balances';
  final String moduleStaking = 'Staking';
  final String moduleDemocracy = 'Democracy';
  final String moduleRecovery = 'Recovery';

  static String getSnEndpoint(String network) {
    return 'https://$network.api.subscan.io/api/scan';
  }

  /// do the request in an isolate to avoid UI stall
  /// in IOS due to https issue: https://github.com/dart-lang/sdk/issues/41519
  Future<Map> fetchTransfersAsync(
    String address,
    int page, {
    int size = txListPageSize,
    String network = 'kusama',
  }) async {
    final Completer completer = Completer<Map>();

    final ReceivePort receivePort = ReceivePort();
    final Isolate isolateIns = await Isolate.spawn(
        SubScanApi.fetchTransfers,
        SubScanRequestParams(
          sendPort: receivePort.sendPort,
          network: network,
          address: address,
          page: page,
          row: size,
        ));
    receivePort.listen((msg) {
      receivePort.close();
      isolateIns.kill(priority: Isolate.immediate);
      completer.complete(msg);
    });
    return completer.future as FutureOr<Map<dynamic, dynamic>>;
  }

  Future<Map> fetchTxsAsync(
    String module, {
    String? call,
    int page = 0,
    int size = txListPageSize,
    String? sender,
    String network = 'kusama',
  }) async {
    final Completer completer = Completer<Map>();

    final ReceivePort receivePort = ReceivePort();
    final Isolate isolateIns = await Isolate.spawn(
        SubScanApi.fetchTxs,
        SubScanRequestParams(
          sendPort: receivePort.sendPort,
          network: network,
          module: module,
          call: call,
          address: sender,
          page: page,
          row: size,
        ));
    receivePort.listen((msg) {
      receivePort.close();
      isolateIns.kill(priority: Isolate.immediate);
      completer.complete(msg);
    });
    return completer.future as FutureOr<Map<dynamic, dynamic>>;
  }

  Future<Map> fetchRewardTxsAsync({
    int page = 0,
    int size = txListPageSize,
    String? sender,
    String network = 'kusama',
  }) async {
    final Completer completer = Completer<Map>();

    final ReceivePort receivePort = ReceivePort();
    final Isolate isolateIns = await Isolate.spawn(
        SubScanApi.fetchRewardTxs,
        SubScanRequestParams(
          sendPort: receivePort.sendPort,
          network: network,
          address: sender,
          page: page,
          row: size,
        ));
    receivePort.listen((msg) {
      receivePort.close();
      isolateIns.kill(priority: Isolate.immediate);
      completer.complete(msg);
    });
    return completer.future as FutureOr<Map<dynamic, dynamic>>;
  }

  static Future<Map?> fetchTransfers(SubScanRequestParams params) async {
    final String url = '${getSnEndpoint(params.network!)}/transfers';
    final String body = jsonEncode({
      "page": params.page,
      "row": params.row,
      "address": params.address,
    });
    final Response res = await post(Uri.parse(url), headers: post_headers, body: body);
    final obj = await compute(jsonDecode, res.body);
    if (params.sendPort != null) {
      params.sendPort!.send(obj['data']);
    }
    return obj['data'];
  }

  static Future<Map?> fetchTxs(SubScanRequestParams para) async {
    final String url = '${getSnEndpoint(para.network!)}/extrinsics';
    final Map params = {
      "page": para.page,
      "row": para.row,
      "module": para.module,
    };
    if (para.address != null) {
      params['address'] = para.address;
    }
    if (para.call != null) {
      params['call'] = para.call;
    }
    final String body = jsonEncode(params);
    final Response res = await post(Uri.parse(url), headers: post_headers, body: body);
    final obj = await compute(jsonDecode, res.body);
    if (para.sendPort != null) {
      para.sendPort!.send(obj['data']);
    }
    return obj['data'];
  }

  static Future<Map?> fetchRewardTxs(SubScanRequestParams para) async {
    final String url = '${getSnEndpoint(para.network!)}/account/reward_slash';
    final Map params = {
      "address": para.address,
      "page": para.page,
      "row": para.row,
    };
    final String body = jsonEncode(params);
    final Response res = await post(Uri.parse(url), headers: post_headers, body: body);
    final obj = await compute(jsonDecode, res.body);
    if (para.sendPort != null) {
      para.sendPort!.send(obj['data']);
    }
    return obj['data'];
  }
}
