// ignore_for_file: unnecessary_null_comparison, parameter_assignments, prefer_is_not_operator, prefer_constructors_over_static_methods, prefer_typing_uninitialized_variables, slash_for_doc_comments

import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart';
import 'package:seeds/crypto/dart_esr/src/models/request_signature.dart';
import 'package:seeds/crypto/dart_esr/src/utils/base64u.dart';

// ignore: library_prefixes
import 'package:seeds/crypto/eosdart/eosdart.dart' as eosDart;

class SigningRequestManager {
  static eosDart.Type? type(int version) => ESRConstants.signingRequestAbiType(version)['signing_request'];
  static eosDart.Type? idType(int version) => ESRConstants.signingRequestAbiType(version)['identity'];
  static eosDart.Type? transactionType(int version) => ESRConstants.signingRequestAbiType(version)['transaction'];

  int version;
  SigningRequest data;
  TextEncoder? textEncoder;
  TextDecoder? textDecoder;
  ZlibProvider? zlib;
  AbiProvider? abiProvider;
  RequestSignature? signature;

  /**
    * Create a new signing request.
    * Normally not used directly, see the `create` and `from` class methods.
    */
  SigningRequestManager(this.version, this.data, this.textEncoder, this.textDecoder,
      {this.zlib, this.abiProvider, this.signature}) {
    if (data.flags & ESRConstants.RequestFlagsBroadcast != 0 && data.req!.first is Identity) {
      throw 'Invalid request (identity request cannot be broadcast)';
    }
    if (data.flags & ESRConstants.RequestFlagsBroadcast == 0 && data.callback!.isEmpty) {
      throw 'Invalid request (nothing to do, no broadcast or callback set)';
    }
  }

  /// Create a new signing request. */
  static Future<SigningRequestManager> create(
    SigningRequestCreateArguments args, {
    SigningRequestEncodingOptions? options,
  }) async {
    options ??= defaultSigningRequestEncodingOptions();
    final TextEncoder? textEncoder = (options.textEncoder ?? DefaultTextEncoder) as TextEncoder?;
    final TextDecoder? textDecoder = (options.textDecoder ?? TextDecoder) as TextDecoder?;

    final data = SigningRequest();
    // set the request data
    if (args.identity != null) {
      data.req = ['identity', args.identity!.toJson()];
    } else if (args.action != null && args.actions == null && args.transaction == null) {
      // ignore: unnecessary_null_checks
      await SigningRequestUtils.serializeAction(args.action!, abiProvider: options.abiProvider);

      data.req = ['action', args.action!.toJson()];
    } else if (args.actions != null && args.action == null && args.transaction == null) {
      await SigningRequestUtils.serializeActions(args.actions!, abiProvider: options.abiProvider);

      final jsonAction = [];
      for (final action in args.actions!) {
        jsonAction.add(action.toJson());
      }
      if (args.actions!.length == 1) {
        data.req = ['action', jsonAction.first];
      } else {
        data.req = ['action[]', jsonAction];
      }
    } else if (args.transaction != null && args.action == null && args.actions == null) {
      final tx = args.transaction!;

      // set default values if missing
      tx.expiration ??= DateTime.parse('1970-01-01T00:00:00.000');
      tx.refBlockNum ??= 0;
      tx.refBlockPrefix ??= 0;
      tx.contextFreeActions ??= [];
      tx.transactionExtensions ??= [];
      tx.delaySec ??= 0;
      tx.maxCpuUsageMs ??= 0;
      tx.maxNetUsageWords ??= 0;

      // encode actions if needed
      await SigningRequestUtils.serializeActions(tx.actions!, abiProvider: options.abiProvider);
      data.req = ['transaction', tx.toJson()];
    } else {
      throw 'Invalid arguments: Must have exactly one of action, actions or transaction';
    }

    // set the chain id
    data.chainId = SigningRequestUtils.variantId(args.chainId);

    data.flags = ESRConstants.RequestFlagsNone;
    // ignore: avoid_bool_literals_in_conditional_expressions
    final broadcast = args.broadcast != null ? args.broadcast! : true;
    if (broadcast) {
      data.flags |= ESRConstants.RequestFlagsBroadcast;
    }
    if (args.callback is CallbackType) {
      data.callback = args.callback!.url;
      if (args.callback!.background) {
        data.flags |= ESRConstants.RequestFlagsBackground;
      }
    } else {
      data.callback = '';
    }

    data.info = [];
    if (args.info != null) {
      args.info!.forEach((key, value) {
        Uint8List encodedValue;
        if (value is Uint8List) {
          encodedValue = value;
        } else if (value is String) {
          encodedValue = textEncoder!.encode(value);
        } else {
          throw 'info value must be either a string or a Uint8List';
        }
        data.info.add(InfoPair()
          ..key = key
          ..value = eosDart.arrayToHex(encodedValue));
      });
    }

    final req = SigningRequestManager(ESRConstants.ProtocolVersion, data, textEncoder, textDecoder,
        zlib: options.zlib, abiProvider: options.abiProvider);

    if (options.signatureProvider != null) {
      req.sign(options.signatureProvider!);
    }
    return req;
  }

  /// Creates an identity request. */
  static Future<SigningRequestManager> identity(SigningRequestCreateIdentityArguments args,
      {SigningRequestEncodingOptions? options}) async {
    final permission = Authorization();
    permission.actor = args.account != null || args.account!.isEmpty ? args.account : ESRConstants.PlaceholderName;
    permission.permission =
        args.permission != null || args.permission!.isEmpty ? args.permission : ESRConstants.PlaceholderName;

    final createArgs = SigningRequestCreateArguments(
        chainId: args.chainId,
        identity: Identity()..authorization = permission,
        broadcast: false,
        callback: args.callback,
        info: args.info);

    // ignore: unnecessary_await_in_return
    return await SigningRequestManager.create(createArgs, options: options);
  }

  /**
   * Create a request from a chain id and serialized transaction.
   * @param chainId The chain id where the transaction is valid.
   * @param serializedTransaction The serialized transaction.
   * @param options Creation options.
   */
  static SigningRequestManager fromTransaction(dynamic chainId, dynamic serializedTransaction,
      {required SigningRequestEncodingOptions options}) {
    if (chainId is String) {
      chainId = eosDart.arrayToHex(chainId as Uint8List);
    }
    if (serializedTransaction is String) {
      serializedTransaction = eosDart.hexToUint8List(serializedTransaction);
    }

    final buf = eosDart.SerialBuffer(Uint8List(0));

    buf.push([2]);
    final id = SigningRequestUtils.variantId(chainId);
    if (id[0] == 'chain_alias') {
      buf.push([0]);
      buf.push(id[1]);
    } else {
      buf.push([1]);
      buf.pushArray(eosDart.hexToUint8List(id[1]));
    }
    buf.push([2]); // transaction variant
    buf.pushArray(serializedTransaction);
    buf.push([ESRConstants.RequestFlagsBroadcast]); // flags
    buf.push([0]); // callback
    buf.push([0]); // info

    return SigningRequestManager.fromData(buf.asUint8List(), options: options);
  }

  /// Creates a signing request from encoded `esr:` uri string. */
  static SigningRequestManager from(String? uri, {required SigningRequestEncodingOptions options}) {
    if (!(uri is String)) {
      throw 'Invalid request uri';
    }
    final splitUri = uri.split(':');
    final scheme = splitUri[0];
    final path = splitUri[1];
    if (scheme != 'esr' && scheme != 'web+esr') {
      throw 'Invalid scheme';
    }
    final data = Base64u().decode(path.startsWith('//') ? path.substring(2) : path);
    return SigningRequestManager.fromData(data, options: options);
  }

  static SigningRequestManager fromData(Uint8List data, {required SigningRequestEncodingOptions options}) {
    final header = data.first;
    final version = header & ~(1 << 7);
    if (!(version == ESRConstants.ProtocolVersion || version == ESRConstants.ProtocolVersion3)) {
      throw 'Unsupported protocol version: $version';
    }
    Uint8List? array = data.sublist(1);
    if ((header & (1 << 7)) != 0) {
      if (options.zlib == null) {
        throw 'Compressed URI needs zlib';
      }
      array = options.zlib!.inflateRaw(array);
    }

    final textEncoder = options.textEncoder ?? DefaultTextEncoder;
    final textDecoder = options.textDecoder ?? DefaultTextDecoder;

    final buf = eosDart.SerialBuffer(array!);

    final signingRequest = SigningRequest.fromBinary(type(version)!, buf);

    RequestSignature? signature;
    if (buf.haveReadData()) {
      signature = RequestSignature.fromBinary(ESRConstants.signingRequestAbiType(version)['request_signature']!, buf);
    }

    return SigningRequestManager(version, signingRequest, textEncoder as TextEncoder?, textDecoder as TextDecoder?,
        zlib: options.zlib, abiProvider: options.abiProvider, signature: signature);
  }

  /// Sign the request, mutating.
  /// @param signatureProvider The signature provider that provides a signature for the signer.
  void sign(SignatureProvider signatureProvider) {
    final message = getSignatureDigest();
    signature = signatureProvider.sign(eosDart.arrayToHex(message));
  }

  /// Get the signature digest for this request.
  Uint8List getSignatureDigest() {
    final buffer = eosDart.SerialBuffer(Uint8List(0));

    // protocol version + utf8 "request"
    buffer.pushArray([version, 0x72, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74]);
    buffer.pushArray(getData());
    return sha256.convert(buffer.asUint8List()).bytes as Uint8List;
  }

  /// Set the signature data for this request, mutating.
  /// @param signer Account name of signer.
  /// @param signature The signature string.
  void setSignature(String signer, String signature) {
    this.signature = RequestSignature()
      ..signer = signer
      ..signature = signature;
  }

  /// Set the request callback, mutating.
  /// @param url Where the callback should be sent.
  /// @param background Whether the callback should be sent in the background.
  void setCallback(String url, bool background) {
    data.callback = url;
    if (background) {
      data.flags |= ESRConstants.RequestFlagsBackground;
    } else {
      data.flags &= ~ESRConstants.RequestFlagsBackground;
    }
  }

  /// Set broadcast flag.
  /// @param broadcast Whether the transaction should be broadcast by receiver.
  void setBroadcast(bool broadcast) {
    if (broadcast) {
      data.flags |= ESRConstants.RequestFlagsBroadcast;
    } else {
      data.flags &= ~ESRConstants.RequestFlagsBroadcast;
    }
  }

  /// Encode this request into an `esr:` uri.
  /// @argument compress Whether to compress the request data using zlib,
  ///                    defaults to true if omitted and zlib is present;
  ///                    otherwise false.
  /// @argument slashes Whether add slashes after the protocol scheme, i.e. `esr://`.
  ///                   Defaults to true.
  /// @returns An esr uri string.
  String encode({bool? compress, bool slashes = true}) {
    final shouldCompress = compress ?? zlib != null;
    if (shouldCompress && zlib == null) {
      throw 'Need zlib to compress';
    }
    var header = version;
    final data = getData();
    final sigData = getSignatureData();
    final temp = <int>[];
    temp.addAll(data);
    temp.addAll(sigData);
    Uint8List? array = Uint8List.fromList(temp);
    if (shouldCompress) {
      final deflated = zlib?.deflateRaw(array);
      header |= 1 << 7;
      array = deflated;
    }
    final out = <int>[];
    out.add(header);
    out.addAll(array!);
    var scheme = ESRConstants.Scheme;
    if (slashes) {
      scheme += '//';
    }
    return scheme + Base64u().encode(Uint8List.fromList(out));
  }

  /// Get the request data without header or signature. */
  Uint8List getData() {
    return data.toBinary(SigningRequestManager.type(version)!);
  }

  /// Get signature data, returns an empty array if request is not signed. */
  Uint8List getSignatureData() {
    if (signature == null) {
      return Uint8List(0);
    }
    final buffer = eosDart.SerialBuffer(Uint8List(0));
    final type = ESRConstants.signingRequestAbiType(version)['request_signature']!;
    type.serialize!(buffer, signature);
    return buffer.asUint8List();
  }

  /// ABI definitions required to resolve request. */
  List<String?> getRequiredAbis() {
    final rawActions = getRawActions();
    rawActions.removeWhere((Action action) => SigningRequestUtils.isIdentity(action));
    return rawActions.map((action) => action.account).toSet().toList();
  }

  /// Whether TaPoS values are required to resolve request. */
  bool requiresTapos() {
    final tx = getRawTransaction();
    return !isIdentity() && !SigningRequestUtils.hasTapos(tx);
  }

  /// Resolve required ABI definitions. */
  Future<Map<String?, dynamic>> fetchAbis({AbiProvider? abiProvider}) async {
    final provider = abiProvider ?? this.abiProvider;
    if (provider == null) {
      throw 'Missing ABI provider';
    }
    final abis = <String?, dynamic>{};

    await Future.forEach(getRequiredAbis(), (dynamic account) async {
      abis[account] = await provider.getAbi(account);
    });
    return abis;
  }

  /// Decode raw actions actions to object representations.
  /// @param abis ABI defenitions required to decode all actions.
  /// @param signer Placeholders in actions will be resolved to signer if set.
  List<Action> resolveActions(Map<String?, dynamic> abis, Authorization signer) {
    return getRawActions().map((rawAction) {
      eosDart.Abi? contractAbi;
      if (SigningRequestUtils.isIdentity(rawAction)) {
        contractAbi = ESRConstants.signingRequestAbi(version);
      } else {
        contractAbi = abis[rawAction.account];
      }
      if (contractAbi == null) {
        throw 'Missing ABI definition for ${rawAction.account}';
      }
      final contract = SigningRequestUtils.getContract(contractAbi);

      contract.types['name']?.deserialize =
          (eosDart.Type type, eosDart.SerialBuffer buffer, {bool? allowExtensions, eosDart.SerializerState? state}) {
        final name = buffer.getName();
        if (name == ESRConstants.PlaceholderName) {
          return signer.actor;
        } else if (name == ESRConstants.PlaceholderPermission) {
          return signer.permission;
        } else {
          return name;
        }
      };

      final action = SigningRequestUtils.deserializeAction(version, contract, rawAction.account!, rawAction.name,
          rawAction.authorization, rawAction.data, textEncoder, textDecoder);

      if (signer != null) {
        for (final auth in action.authorization!) {
          if (auth!.actor == ESRConstants.PlaceholderName) {
            auth.actor = signer.actor;
          }
          if (auth.permission == ESRConstants.PlaceholderPermission) {
            auth.permission = signer.permission;
          }
          // backwards compatibility, actor placeholder will also resolve to permission when used in auth
          if (auth.permission == ESRConstants.PlaceholderName) {
            auth.permission = signer.permission;
          }
        }
      }
      return action;
    }).toList();
  }

  Transaction resolveTransaction(Map<String?, dynamic> abis, Authorization signer, TransactionContext ctx) {
    final tx = getRawTransaction();
    if (!isIdentity() && !SigningRequestUtils.hasTapos(tx)) {
      if (ctx.expiration != null && ctx.refBlockNnum != null && ctx.refBlockPrefix != null) {
        tx.expiration = ctx.expiration;
        tx.refBlockNum = ctx.refBlockNnum;
        tx.refBlockPrefix = ctx.refBlockPrefix;
      } else if (ctx.blockNum != null && ctx.refBlockPrefix != null && ctx.timestamp != null) {
        tx.expiration = ctx.timestamp!.add(Duration(seconds: ctx.expireSeconds != null ? ctx.expireSeconds! : 60));
        tx.refBlockNum = ctx.blockNum! & 0xffff;
        tx.refBlockPrefix = ctx.refBlockPrefix;
      } else {
        throw 'Invalid transaction context, need either a reference block or explicit TAPoS values';
      }
    }
    tx.actions = resolveActions(abis, signer);

    return tx;
  }

  ResolvedSigningRequest resolve(Map<String?, dynamic> abis, Authorization signer, TransactionContext ctx) {
    final transaction = resolveTransaction(abis, signer, ctx);

    for (final action in transaction.actions!) {
      var contractAbi;
      if (SigningRequestUtils.isIdentity(action)) {
        contractAbi = ESRConstants.signingRequestAbi;
      } else {
        contractAbi = abis[action?.account];
      }
      if (contractAbi == null) {
        throw 'Missing ABI definition for ${action?.account}';
      }
      SigningRequestUtils.serializeAction(action, abi: contractAbi);
    }

    final serializedTransaction = transaction.toBinary(SigningRequestManager.transactionType(version)!);

    return ResolvedSigningRequest(this, signer, transaction, serializedTransaction);
  }

  /// Get the id of the chain where this request is valid.
  /// @returns The 32-byte chain id as hex encoded string.
  String? getChainId() {
    final id = data.chainId!;
    switch (id[0]) {
      case 'chain_id':
        return id[1];
      case 'chain_alias':
        if (ESRConstants.ChainIdLookup.containsKey(id[1])) {
          return ESRConstants.ChainIdLookup[id[1]];
        } else {
          throw 'Unknown chain id alias';
        }
      default:
        throw 'Invalid signing request data';
    }
  }

  /// Return the actions in this request with action data encoded. */
  List<Action> getRawActions() {
    final req = data.req!;
    switch (req[0]) {
      case 'action':
        return [Action.fromJson(Map<String, dynamic>.from(req[1]))];
      case 'action[]':
        print("*** actions: ${req.toString()}");

        final actions = req[1] as List;
        final List<Action> resultActions = List.from(actions.map(
          (e) => Action.fromJson(Map<String, dynamic>.from(e)),
        ));
        // TODO(n13): return list of actions  - note this code is duplicated elsewhere we already handle multiple actions
        return resultActions;
      case 'identity':
        var data = '0101000000000000000200000000000000'; // placeholder permission
        var authorization = [ESRConstants.PlaceholderAuth];
        final req1 = req[1];
        if (req1['permission'] != null) {
          final auth = Authorization()
            ..actor = req1['permission']['actor'] ?? ESRConstants.PlaceholderName
            ..permission = req1['permission']['permission'] ?? ESRConstants.PlaceholderPermission;

          final identity = Identity()..authorization = auth;

          data = eosDart.arrayToHex(identity.toBinary(SigningRequestManager.idType(version)!));
          authorization = [auth];
        }
        return [
          Action()
            ..account = ''
            ..name = 'identity'
            ..authorization = authorization
            ..data = data
        ];
      case 'transaction':
        final List<dynamic> actionsRaw = req[1]['actions'];
        final List<Action> actions = [];
        for (final item in actionsRaw) {
          actions.add(Action.fromJson(Map<String, dynamic>.from(item)));
        }
        return actions;
      default:
        throw 'Invalid signing request data';
    }
  }

  /// Unresolved transaction. */
  Transaction getRawTransaction() {
    final req = data.req!;
    switch (req[0]) {
      case 'transaction':
        return req[1];
      case 'action':
      case 'action[]':
      case 'identity':
        return Transaction()
          ..actions = getRawActions()
          ..contextFreeActions = []
          ..transactionExtensions = []
          ..expiration = DateTime.parse('1970-01-01T00:00:00.000')
          ..refBlockNum = 0
          ..refBlockPrefix = 0
          ..maxCpuUsageMs = 0
          ..maxNetUsageWords = 0
          ..delaySec = 0;

      default:
        throw 'Invalid signing request data';
    }
  }

  /// Whether the request is an identity request. */
  bool isIdentity() {
    return data.req![0] == 'identity';
  }

  /// Whether the request should be broadcast by signer. */
  bool shouldBroadcast() {
    if (isIdentity()) {
      return false;
    }
    return (data.flags & ESRConstants.RequestFlagsBroadcast) != 0;
  }

  /// Present if the request is an identity request and requests a specific account.
  /// @note This returns `nil` unless a specific identity has been requested,
  ///       use `isIdentity` to check id requests.
  String? getIdentity() {
    if (data.req![0] == 'identity') {
      try {
        final req1 = data.req![1] as Identity;
        if (req1.authorization != null) {
          final actor = req1.authorization!.actor;
          return actor == ESRConstants.PlaceholderName ? null : actor;
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Present if the request is an identity request and requests a specific permission.
  /// @note This returns `nil` unless a specific permission has been requested,
  ///       use `isIdentity` to check id requests.
  String? getIdentityPermission() {
    if (data.req![0] == 'identity') {
      try {
        final req1 = data.req![1] as Identity;
        if (req1.authorization != null) {
          final permission = req1.authorization!.permission;
          return permission == ESRConstants.PlaceholderName ? null : permission;
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Get raw info dict */
  Map<String?, Uint8List> getRawInfo() {
    final rv = <String?, Uint8List>{};
    for (final element in data.info) {
      rv[element.key] = eosDart.hexToUint8List(element.value!);
    }
    return rv;
  }

  /// Get metadata values as strings. */
  Map<String?, String> getInfo() {
    final rv = <String?, String>{};
    final raw = getRawInfo();
    raw.forEach((key, value) {
      rv[key] = textDecoder!.decode(value);
    });
    return rv;
  }

  /** Set a metadata key. 
   * value : string | boolean
  */
  void setInfoKey(String key, dynamic value) {
    Uint8List encodedValue;
    switch (value.runtimeType) {
      case String:
        encodedValue = textEncoder!.encode(value);
        break;
      case bool:
        encodedValue = Uint8List(1);
        encodedValue[0] = value ? 1 : 0;
        break;
      default:
        throw 'Invalid value type, expected string or boolean.';
    }
    final infoPair = InfoPair()
      ..key = key
      ..value = eosDart.arrayToHex(encodedValue);

    final index = data.info.indexWhere((element) => element.key == key);
    if (index >= 0) {
      data.info[index] = infoPair;
    } else {
      data.info.add(infoPair);
    }
  }

  /// Return a deep copy of this request. */
  SigningRequestManager clone() {
    RequestSignature? signature;
    if (this.signature != null) {
      signature = RequestSignature.clone(this.signature!.signer, this.signature!.signature);
    }
    final data = this.data.toJson();

    return SigningRequestManager(version, SigningRequest.fromJson(data), textEncoder, textDecoder,
        zlib: zlib, abiProvider: abiProvider, signature: signature);
  }

  // Convenience methods.

  @override
  String toString() {
    return encode();
  }

  String toJSON() {
    return encode();
  }
}

class ResolvedSigningRequest {
  SigningRequestManager request;
  Authorization signer;
  Transaction transaction;
  Uint8List serializedTransaction;

  /// Recreate a resolved request from a callback payload. */
  static Future<ResolvedSigningRequest> fromPayload(
      CallbackPayload payload, SigningRequestEncodingOptions options) async {
    final request = SigningRequestManager.from(payload.req, options: options);
    final abis = await request.fetchAbis(abiProvider: options.abiProvider);

    int? refBlockNnum;
    int? refBlockPrefix;
    try {
      refBlockNnum = int.parse(payload.rbn!);
      refBlockPrefix = int.parse(payload.rid!);
    } catch (e) {
      print("Error fromPayload: ${e.toString()}");
    }

    return request.resolve(
        abis,
        Authorization()
          ..actor = payload.sa
          ..permission = payload.sp,
        TransactionContext(
            refBlockNnum: refBlockNnum ?? 0,
            refBlockPrefix: refBlockPrefix ?? 0,
            expiration: DateTime.parse(payload.ex!)));
  }

  ResolvedSigningRequest(this.request, this.signer, this.transaction, this.serializedTransaction);

  String getTransactionId() {
    return eosDart.arrayToHex(sha256.convert(serializedTransaction).bytes as Uint8List);
  }

  ResolvedCallback getCallback(List<String> signatures, {int? blockNum}) {
    // TODO(n13): ResolvedSigningRequest getCallback 'not implemented yet'
    throw 'not implemented yet';
  }
}

class SigningRequestUtils {
  static eosDart.Contract getContract(eosDart.Abi contractAbi) {
    final types = eosDart.getTypesFromAbi(eosDart.createInitialTypes(), contractAbi);
    final actions = <String?, eosDart.Type>{};

    for (final action in contractAbi.actions!) {
      actions[action!.name] = eosDart.getType(types, action.type);
    }

    return eosDart.Contract(types, actions);
  }

  static Future<void> serializeActions(List<Action?> actions, {AbiProvider? abiProvider}) async {
    await Future.forEach(
        actions, (dynamic action) => SigningRequestUtils.serializeAction(action, abiProvider: abiProvider));
  }

  static Future<void> serializeAction(
    Action? action, {
    eosDart.Abi? abi,
    AbiProvider? abiProvider,
    int version = 2,
  }) async {
    if (action?.data is String) {
      return;
    }
    var contractAbi;
    if (abi != null) {
      contractAbi = abi;
    } else if (SigningRequestUtils.isIdentity(action)) {
      contractAbi = ESRConstants.signingRequestAbi(version);
    } else if (abiProvider != null) {
      contractAbi = await abiProvider.getAbi(action?.account);
    }
    if (contractAbi == null) {
      throw 'Missing abi provider';
    }
    final contract = SigningRequestUtils.getContract(contractAbi);
    await EOSSerializeUtils.serializeActions(version, contract, action);
  }

  static Action deserializeAction(int version, eosDart.Contract contract, String account, String? name,
      List<Authorization?>? authorization, dynamic data, TextEncoder? textEncoder, TextDecoder? textDecoder) {
    return EOSSerializeUtils.deserializeAction(
        version, contract, account, name, authorization, data, textEncoder, textDecoder);
  }

  /// chainId : int | String | ChainName
  static List<dynamic> variantId(dynamic chainId) {
    // ignore: prefer_conditional_assignment
    if (chainId == null) {
      chainId = ChainName.EOS;
    }
    switch (chainId.runtimeType) {
      case int:
        return ['chain_alias', chainId];
      case String:
        return ['chain_id', chainId];
      case ChainName:
        chainId = ESRConstants.ChainIdLookup[chainId];
        return ['chain_id', chainId];
      default:
        throw 'Invalid arguments: chainId must be of type int | String | ChainName';
    }
  }

  static bool isIdentity(Action? action) {
    return action?.account == '' && action?.name == 'identity';
  }

  static bool hasTapos(Transaction tx) {
    return !(tx.expiration == DateTime.parse('1970-01-01T00:00:00.000') &&
        tx.refBlockNum == 0 &&
        tx.refBlockPrefix == 0);
  }

  /// Resolve a chain id to a chain name alias, returns UNKNOWN (0x00) if the chain id has no alias. */
  ChainName idToName(String chainId) {
    chainId = chainId.toLowerCase();
    ESRConstants.ChainIdLookup.containsValue(chainId);
    return ESRConstants.ChainIdLookup.keys.firstWhere((key) => ESRConstants.ChainIdLookup[key] == chainId);
  }

  /// Resolve a chain name alias to a chain id. */
  static String? nameToId(ChainName chainName) {
    if (ESRConstants.ChainIdLookup.containsKey(chainName)) {
      return ESRConstants.ChainIdLookup[chainName];
    }
    return ESRConstants.ChainIdLookup[ChainName.RESERVED];
  }
}
