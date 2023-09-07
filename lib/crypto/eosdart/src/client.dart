import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:seeds/crypto/eosdart/src/eosdart_base.dart';
import 'package:seeds/crypto/eosdart/src/jsons.dart';
import 'package:seeds/crypto/eosdart/src/models/abi.dart';
import 'package:seeds/crypto/eosdart/src/models/account.dart';
import 'package:seeds/crypto/eosdart/src/models/action.dart';
import 'package:seeds/crypto/eosdart/src/models/action_block.dart';
import 'package:seeds/crypto/eosdart/src/models/block.dart';
import 'package:seeds/crypto/eosdart/src/models/block_header_state.dart';
import 'package:seeds/crypto/eosdart/src/models/node_info.dart';
import 'package:seeds/crypto/eosdart/src/models/primary_wrapper.dart';
import 'package:seeds/crypto/eosdart/src/models/transaction.dart';
import 'package:seeds/crypto/eosdart/src/serialize.dart' as ser;
import 'package:seeds/crypto/eosdart_ecc/eosdart_ecc.dart' as ecc;

/// EOSClient calls APIs against given EOS nodes
class EOSClient {
  final String _nodeURL;
  final String _version;
  int expirationInSec;
  int httpTimeout;
  Map<String, ecc.EOSPrivateKey> keys = {};

  /// Converts abi files between binary and structured form (`abi.abi.json`) */
  Map<String?, Type>? abiTypes;
  late Map<String?, Type> transactionTypes;

  /// Construct the EOS client from eos node URL
  EOSClient(
    this._nodeURL,
    this._version, {
    this.expirationInSec = 180,
    List<String> privateKeys = const [],
    this.httpTimeout = 10,
  }) {
    _mapKeys(privateKeys);

    abiTypes = ser.getTypesFromAbi(ser.createInitialTypes(), Abi.fromJson(json.decode(abiJson)));
    transactionTypes = ser.getTypesFromAbi(ser.createInitialTypes(), Abi.fromJson(json.decode(transactionJson)));
  }

  /// Sets private keys. Required to sign transactions.
  void _mapKeys(List<String> privateKeys) {
    for (final String privateKey in privateKeys) {
      final ecc.EOSPrivateKey pKey = ecc.EOSPrivateKey.fromString(privateKey);
      final String publicKey = pKey.toEOSPublicKey().toString();
      keys[publicKey] = pKey;
    }
  }

  // ignore: avoid_setters_without_getters
  set privateKeys(List<String> privateKeys) => _mapKeys(privateKeys);

  Future _post(String path, Object body) async {
    final Completer completer = Completer();
    // ignore: unawaited_futures
    http
        .post(Uri.parse('$_nodeURL/$_version$path'), body: json.encode(body))
        .timeout(Duration(seconds: httpTimeout))
        .then((http.Response response) {
      if (response.statusCode >= 300) {
        completer.completeError(response.body);
      } else {
        completer.complete(json.decode(response.body));
      }
    });
    return completer.future;
  }

  /// Get EOS Node Info
  Future<NodeInfo> getInfo() async {
    return _post('/chain/get_info', {}).then((nodeInfo) {
      final NodeInfo info = NodeInfo.fromJson(nodeInfo);
      return info;
    });
  }

  /// Get table rows (eosio get table ...)
  Future<List<Map<String, dynamic>>?> getTableRows(
    String code,
    String scope,
    String table, {
    bool json = true,
    String tableKey = '',
    String lower = '',
    String upper = '',
    int indexPosition = 1,
    String keyType = '',
    int limit = 10,
    bool reverse = false,
  }) async {
    final dynamic result = await _post('/chain/get_table_rows', {
      'json': json,
      'code': code,
      'scope': scope,
      'table': table,
      'table_key': tableKey,
      'lower_bound': lower,
      'upper_bound': upper,
      'index_position': indexPosition,
      'key_type': keyType,
      'limit': limit,
      'reverse': reverse,
    });
    if (result is Map) {
      return result['rows'].cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Get table row (eosio get table ...)
  Future<Map<String, dynamic>?> getTableRow(
    String code,
    String scope,
    String table, {
    bool json = true,
    String tableKey = '',
    String lower = '',
    String upper = '',
    int indexPosition = 1,
    String keyType = '',
    bool reverse = false,
  }) async {
    final rows = await (getTableRows(
      code,
      scope,
      table,
      json: json,
      tableKey: tableKey,
      lower: lower,
      upper: upper,
      indexPosition: indexPosition,
      keyType: keyType,
      limit: 1,
      reverse: reverse,
    ) as FutureOr<List<Map<String, dynamic>>>);

    return rows.isNotEmpty ? rows[0] : null;
  }

  /// Get EOS Block Info
  Future<Block> getBlock(String blockNumOrId) async {
    return _post('/chain/get_block', {'block_num_or_id': blockNumOrId}).then((block) {
      return Block.fromJson(block);
    });
  }

  /// Get EOS Block Header State
  Future<BlockHeaderState> getBlockHeaderState(String blockNumOrId) async {
    return _post('/chain/get_block_header_state', {'block_num_or_id': blockNumOrId}).then((block) {
      return BlockHeaderState.fromJson(block);
    });
  }

  /// Get EOS abi from account name
  Future<AbiResp> getAbi(String accountName) async {
    return _post('/chain/get_abi', {'account_name': accountName}).then((abi) {
      return AbiResp.fromJson(abi);
    });
  }

  /// Get EOS raw abi from account name
  Future<AbiResp> getRawAbi(String? accountName) async {
    return _post('/chain/get_raw_abi', {'account_name': accountName}).then((abi) {
      return AbiResp.fromJson(abi);
    });
  }

  /// Get EOS raw code and abi from account name
  Future<AbiResp> getRawCodeAndAbi(String accountName) async {
    return _post('/chain/get_raw_code_and_abi', {'account_name': accountName}).then((abi) {
      return AbiResp.fromJson(abi);
    });
  }

  /// Get EOS account info form the given account name
  Future<Account> getAccount(String accountName) async {
    return _post('/chain/get_account', {'account_name': accountName}).then((account) {
      return Account.fromJson(account);
    });
  }

  /// Get EOS account info form the given account name
  Future<List<Holding>> getCurrencyBalance(String code, String account, [String? symbol]) async {
    return _post('/chain/get_currency_balance', {'code': code, 'account': account, 'symbol': symbol}).then((balance) {
      return (balance as List).map((e) => Holding.fromJson(e)).toList();
    });
  }

  /// Get required key by transaction from EOS blockchain
  Future<RequiredKeys> getRequiredKeys(Transaction transaction, List<String> availableKeys) async {
    final NodeInfo info = await getInfo();
    final Block refBlock = await getBlock((info.headBlockNum).toString());
    Transaction trx = await _fullFill(transaction, refBlock);
    trx = await _serializeActions(trx);

    // raw abi to json
//      AbiResp abiResp = await getRawAbi(account);
//    print(abiResp.abi);
    return _post('/chain/get_required_keys', {'transaction': trx, 'available_keys': availableKeys})
        .then((requiredKeys) {
      return RequiredKeys.fromJson(requiredKeys);
    });
  }

  /// Get EOS account actions
  Future<Actions> getActions(String accountName, {int? pos, int? offset}) async {
    return _post('/history/get_actions', {'account_name': accountName, 'pot': pos, 'offset': offset}).then((actions) {
      return Actions.fromJson(actions);
    });
  }

  /// Get EOS transaction
  Future<TransactionBlock> getTransaction(String id, {int? blockNumHint}) async {
    return _post('/history/get_transaction', {'id': id, 'block_num_hint': blockNumHint}).then((transaction) {
      return TransactionBlock.fromJson(transaction);
    });
  }

  /// Get Key Accounts

  // Get Key Accounts using new API: new get_accounts_by_authorizers API
  Future<AccountNames> getAccountsByKey(String pubKey) async {
    try {
      return _post('/chain/get_accounts_by_authorizers', {
        'accounts': [],
        'keys': [pubKey]
      }).then((response) {
        final List<String> accountNames = List.from(response['accounts'].map((e) => e['account_name']));
        return AccountNames()..accountNames = accountNames.toSet().toList();
      });
    } catch (e) {
      print("getAccountsByKey error $e");
      return AccountNames();
    }
  }

  // Get Key Accounts using new API: new get_accounts_by_authorizers API
  // Future<AccountNames> getAccountsByKey(String pubKey) async {
  //   try {
  //     return _post('/chain/get_accounts_by_authorizers', {
  //       'accounts': [],
  //       'keys': [pubKey]
  //     }).then((response) {
  //       final List<String> accountNames = List.from(response['accounts'].map((e) => e['account_name']));
  //       return AccountNames()..accountNames = accountNames.toSet().toList();
  //     });
  //   } catch (e) {
  //     print("getAccountsByKey error $e");
  //     return AccountNames();
  //   }
  // }

  /// Push transaction to EOS chain
  Future<dynamic> pushTransaction(Transaction transaction,
      {bool broadcast = true, bool sign = true, int blocksBehind = 3, int expireSecond = 180}) async {
    final NodeInfo info = await getInfo();
    final Block refBlock = await getBlock((info.headBlockNum! - blocksBehind).toString());

    final Transaction trx = await _fullFill(transaction, refBlock);
    final PushTransactionArgs pushTransactionArgs =
        await _pushTransactionArgs(info.chainId, transactionTypes['transaction']!, trx, sign);

    if (broadcast) {
      return _post('/chain/push_transaction', {
        'signatures': pushTransactionArgs.signatures,
        'compression': 0,
        'packed_context_free_data': '',
        'packed_trx': ser.arrayToHex(pushTransactionArgs.serializedTransaction),
      }).then((processedTrx) {
        return processedTrx;
      });
    }

    return pushTransactionArgs;
  }

  /// Get data needed to serialize actions in a contract */
  // ignore: unused_element
  Future<Contract> _getContract(String? accountName, {bool reload = false}) async {
    final abi = await getRawAbi(accountName);
    final types = ser.getTypesFromAbi(ser.createInitialTypes(), abi.abi!);
    // ignore: prefer_collection_literals
    final actions = Map<String?, Type>();
    for (final act in abi.abi!.actions!) {
      actions[act?.name] = ser.getType(types, act?.type);
    }
    final result = Contract(types, actions);
    return result;
  }

  /// Fill the transaction withe reference block data
  Future<Transaction> _fullFill(Transaction transaction, Block refBlock) async {
    transaction.expiration = refBlock.timestamp!.add(Duration(seconds: expirationInSec));
    transaction.refBlockNum = refBlock.blockNum! & 0xffff;
    transaction.refBlockPrefix = refBlock.refBlockPrefix;

    return transaction;
  }

  /// serialize actions in a transaction
  Future<Transaction> _serializeActions(Transaction transaction) async {
    for (final Action? action in transaction.actions!) {
      final String? account = action?.account;

      final Contract contract = await _getContract(account);

      action?.data = _serializeActionData(contract, account, action.name, action.data);
    }
    return transaction;
  }

  /// Convert action data to serialized form (hex) */
  String _serializeActionData(Contract contract, String? account, String? name, Object? data) {
    final action = contract.actions[name];
    if (action == null) {
      throw "Unknown action $name in contract $account";
    }
    final buffer = ser.SerialBuffer(Uint8List(0));
    action.serialize!(action, buffer, data);
    return ser.arrayToHex(buffer.asUint8List());
  }

  Future<PushTransactionArgs> _pushTransactionArgs(
      String? chainId, Type transactionType, Transaction transaction, bool sign) async {
    final List<String> signatures = [];

    final RequiredKeys requiredKeys = await getRequiredKeys(transaction, keys.keys.toList());

    final Uint8List serializedTrx = transaction.toBinary(transactionType);

    if (sign) {
      final Uint8List signBuf = Uint8List.fromList(List.from(ser.stringToHex(chainId!))
        ..addAll(serializedTrx)
        ..addAll(Uint8List(32)));

      for (final String publicKey in requiredKeys.requiredKeys!) {
        final ecc.EOSPrivateKey pKey = keys[publicKey]!;
        signatures.add(pKey.sign(signBuf).toString());
      }
    }

    return PushTransactionArgs(signatures, serializedTrx);
  }
}

class PushTransactionArgs {
  List<String> signatures;
  Uint8List serializedTransaction;

  PushTransactionArgs(this.signatures, this.serializedTransaction);
}
