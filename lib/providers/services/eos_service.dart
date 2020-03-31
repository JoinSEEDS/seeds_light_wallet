import 'package:eosdart/eosdart.dart';
import 'package:flutter/widgets.dart' show BuildContext;
import 'package:provider/provider.dart';
import 'package:teloswallet/constants/config.dart';
import 'package:teloswallet/constants/http_mock_response.dart';

class EosService {
  String privateKey;
  String accountName;
  String baseURL = Config.defaultEndpoint;
  String cpuPrivateKey = Config.cpuPrivateKey;
  EOSClient client;
  bool mockEnabled;

  static EosService of(BuildContext context, {bool listen = true}) =>
      Provider.of(context, listen: listen);

  void update({
    userPrivateKey,
    userAccountName,
    nodeEndpoint,
    bool enableMockTransactions = false,
  }) {
    privateKey = userPrivateKey;
    accountName = userAccountName;
    baseURL = nodeEndpoint;
    mockEnabled = enableMockTransactions;
    if (privateKey != null && privateKey.isNotEmpty) {
      client =
          EOSClient(baseURL, 'v1', privateKeys: [privateKey, cpuPrivateKey]);
    }
  }

  Transaction buildFreeTransaction(List<Action> actions) {
    // List<Authorization> freeAuth = [
    //   Authorization()
    //     ..actor = Config.cpuAccountName
    //     ..permission = "payforcpu",
    //   Authorization()
    //     ..actor = accountName
    //     ..permission = "active"
    // ];

    // Action freeAction = Action()
    //   ..account = Config.cpuAccountName
    //   ..name = 'payforcpu'
    //   ..authorization = freeAuth
    //   ..data = {"account": accountName};

    var transaction = Transaction()
      ..actions = [
//        freeAction,
        ...actions,
      ];

    return transaction;
  }

  Future<dynamic> sendTransaction({ String account, String name, Map<String, String> data }) async {
    print("[eos] send transaction ($account | $name)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = account
        ..name = name
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "active"
        ]
        ..data = data
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> transferTelos({String beneficiary, double amount, String memo}) async {
    print("[eos] transfer telos to $beneficiary ($amount)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = "eosio.token"
        ..name = "transfer"
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "active"
        ]
        ..data = {
          "from": accountName,
          "to": beneficiary,
          "quantity": "${amount.toStringAsFixed(4)} TLOS",
          "memo": memo,
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> buyRam({double amount}) async {
    print("[eos] buy ram ($amount)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = 'eosio.system'
        ..name = 'buyram'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "active"
        ]
        ..data = {
          "payer": accountName,
          "receiver": accountName,
          "quant": "${amount.toStringAsFixed(4)} TLOS"
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> sellRam({int bytes}) async {
    print("[eos] sell ram ($bytes)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = 'eosio.system'
        ..name = 'sellram'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = "active"
        ]
        ..data = {
          "account": accountName,
          "bytes": bytes,
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> delegateBw({double amountNet, double amountCpu}) async {
    print("[eos] delegate bw ($amountNet + $amountCpu)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = 'eosio.system'
        ..name = 'delegatebw'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'active'
        ]
        ..data = {
          "from": accountName,
          "receiver": accountName,
          "stake_net_quantity": "${amountNet.toStringAsFixed(4)} TLOS",
          "stake_cpu_quantity": "${amountCpu.toStringAsFixed(4)} TLOS",
          "transfer": true
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }

  Future<dynamic> undelegateBw({double amountNet, double amountCpu}) async {
    print("[eos] undelegate bw ($amountNet + $amountCpu)");

    if (mockEnabled) {
      return HttpMockResponse.transactionResult;
    }

    Transaction transaction = buildFreeTransaction([
      Action()
        ..account = 'eosio.system'
        ..name = 'undelegatebw'
        ..authorization = [
          Authorization()
            ..actor = accountName
            ..permission = 'active'
        ]
        ..data = {
          "from": accountName,
          "receiver": accountName,
          "unstake_net_quantity": "${amountNet.toStringAsFixed(4)} TLOS",
          "unstake_cpu_quantity": "${amountCpu.toStringAsFixed(4)} TLOS",
          "transfer": true
        }
    ]);

    return client.pushTransaction(transaction, broadcast: true);
  }
}
