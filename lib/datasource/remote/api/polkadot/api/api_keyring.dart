import 'dart:async';

import 'package:seeds/datasource/remote/api/polkadot/api/polkawallet_api.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/addressIconData.dart';
import 'package:seeds/datasource/remote/api/polkadot/api/types/verifyResult.dart';
import 'package:seeds/datasource/remote/api/polkadot/service/service_keyring.dart';
import 'package:seeds/datasource/remote/api/polkadot/storage/keyring.dart';
import 'package:seeds/datasource/remote/api/polkadot/storage/types/keyPairData.dart';
import 'package:seeds/datasource/remote/api/polkadot/webviewWithExtension/types/signExtrinsicParam.dart';

enum KeyType { mnemonic, rawSeed, keystore }
enum CryptoType { sr25519, ed25519 }

/// Keyring API manages keyPairs for through `polkadot-js/keyring`
class ApiKeyring {
  ApiKeyring(this.apiRoot, this.service);

  final PolkawalletApi apiRoot;
  final ServiceKeyring? service;

  /// Generate a set of new mnemonic.
  Future<AddressIconDataWithMnemonic> generateMnemonic(int ss58,
      {CryptoType cryptoType = CryptoType.sr25519, String derivePath = '', String key = ''}) async {
    final mnemonicData =
        await service!.generateMnemonic(ss58, cryptoType: cryptoType, derivePath: derivePath, key: key);
    return mnemonicData;
  }

  /// get address and avatar from mnemonic.
  Future<AddressIconData> addressFromMnemonic(int ss58,
      {CryptoType cryptoType = CryptoType.sr25519, String derivePath = '', required String mnemonic}) async {
    final addressInfo =
        await service!.addressFromMnemonic(ss58, cryptoType: cryptoType, derivePath: derivePath, mnemonic: mnemonic);
    return addressInfo;
  }

  /// get address and avatar from rawSeed.
  Future<AddressIconData> addressFromRawSeed(int ss58,
      {CryptoType cryptoType = CryptoType.sr25519, String derivePath = '', required String rawSeed}) async {
    final addressInfo =
        await service!.addressFromRawSeed(ss58, cryptoType: cryptoType, derivePath: derivePath, rawSeed: rawSeed);
    return addressInfo;
  }

  /// get address and avatar from KeyStore.
  Future<AddressIconData> addressFromKeyStore(int ss58, {required Map keyStore}) async {
    final addressInfo = await service!.addressFromKeyStore(ss58, keyStore: keyStore);
    return AddressIconData.fromJson({
      'address': addressInfo[0][0],
      'svg': addressInfo[0][1],
    });
  }

  /// check mnemonic valid.
  Future<bool> checkMnemonicValid(String mnemonic) async {
    return service!.checkMnemonicValid(mnemonic);
  }

  /// Import account from mnemonic/rawSeed/keystore.
  /// param [cryptoType] can be `sr25519`(default) or `ed25519`.
  /// throw error if import failed.
  /// return null if keystore password check failed.
  Future<Map?> importAccount(
    Keyring keyring, {
    required KeyType keyType,
    required String key,
    required String name,
    required String password,
    CryptoType cryptoType = CryptoType.sr25519,
    String derivePath = '',
  }) async {
    final dynamic acc = await service!.importAccount(
      keyType: keyType,
      key: key,
      name: name,
      password: password,
      cryptoType: cryptoType,
      derivePath: derivePath,
    );
    if (acc == null) {
      return null;
    }
    if (acc['error'] != null) {
      throw Exception(acc['error']);
    }

    return acc;
  }

  /// Add account to local storage.
  Future<KeyPairData> addAccount(
    Keyring keyring, {
    required KeyType keyType,
    required Map acc,
    required String password,
  }) async {
    // save seed and remove it before add account
    if (keyType == KeyType.mnemonic || keyType == KeyType.rawSeed) {
      final String type = keyType.toString().split('.')[1];
      final String? seed = acc[type];
      if (seed != null && seed.isNotEmpty) {
        await keyring.store.encryptSeedAndSave(acc['pubKey'], acc[type], type, password);
        acc.remove(type);
      }
    }

    // save keystore to storage
    await keyring.store.addAccount(acc);

    await updatePubKeyIconsMap(keyring, [acc['pubKey']]);
    await updatePubKeyAddressMap(keyring);
    await updateIndicesMap(keyring, [acc['address']]);

    return KeyPairData.fromJson(acc as Map<String, dynamic>);
  }

  /// Add a contact.
  Future<KeyPairData> addContact(Keyring keyring, Map acc) async {
    final pubKey =
        await (service!.serviceRoot.account.decodeAddress([acc['address']]) as FutureOr<Map<dynamic, dynamic>>);
    acc['pubKey'] = pubKey.keys.toList()[0];

    // save keystore to storage
    await keyring.store.addContact(acc);

    await updatePubKeyAddressMap(keyring);
    await updatePubKeyIconsMap(keyring, [acc['pubKey']]);
    await updateIndicesMap(keyring, [acc['address']]);

    return keyring.contacts.firstWhere((e) => e.pubKey == acc['pubKey']);
  }

  /// Every time we change the keyPairs, we need to update the
  /// pubKey-address map.
  Future<void> updatePubKeyAddressMap(Keyring keyring) async {
    final ls = keyring.store.list.toList();
    ls.addAll(keyring.store.contacts);
    // get new addresses from webView.
    final res = await service!.getPubKeyAddressMap(ls, keyring.store.ss58List);

    // set new addresses to Keyring instance.
    if (res != null && res[keyring.ss58.toString()] != null) {
      keyring.store.updatePubKeyAddressMap(Map<String, Map>.from(res));
    }
  }

  /// This method query account icons and set icons to [Keyring.store]
  /// so we can get icon of an account from [Keyring] instance.
  Future<void> updatePubKeyIconsMap(Keyring keyring, [List? pubKeys]) async {
    final List<String?> ls = [];
    if (pubKeys != null) {
      ls.addAll(List<String>.from(pubKeys));
    } else {
      ls.addAll(keyring.keyPairs.map((e) => e.pubKey).toList() as List<String>);
      ls.addAll(keyring.contacts.map((e) => e.pubKey).toList() as List<String>);
    }

    if (ls.isEmpty) {
      return;
    }
    // get icons from webView.
    final res = await service!.getPubKeyIconsMap(ls);
    // set new icons to Keyring instance.
    if (res != null) {
      final data = {};
      for (final e in res) {
        data[e[0]] = e[1];
      }
      keyring.store.updateIconsMap(Map<String, String>.from(data));
    }
  }

  /// This method query account indices and set data to [Keyring.store]
  /// so we can get index info of an account from [Keyring] instance.
  Future<void> updateIndicesMap(Keyring keyring, [List? addresses]) async {
    final List<String?> ls = [];
    if (addresses != null) {
      ls.addAll(List<String>.from(addresses));
    } else {
      ls.addAll(keyring.allWithContacts.map((e) => e.address).toList() as List<String>);
    }

    if (ls.isEmpty) {
      return;
    }
    // get account indices from webView.
    final res = await apiRoot.account.queryIndexInfo(ls);
    // set new indices to Keyring instance.
    if (res != null) {
      final data = {};
      for (final e in res) {
        data[e['accountId']] = e;
      }
      keyring.store.updateIndicesMap(Map<String, Map>.from(data));
      keyring.allAccounts;
    }
  }

  /// Decrypt and get the backup of seed.
  Future<SeedBackupData?> getDecryptedSeed(Keyring keyring, String password) async {
    final Map? data = await keyring.store.getDecryptedSeed(keyring.current.pubKey, password);
    if (data == null) {
      return null;
    }
    if (data['seed'] == null) {
      data['error'] = 'wrong password';
    }
    return SeedBackupData.fromJson(data as Map<String, dynamic>);
  }

  /// delete account from storage
  Future<void> deleteAccount(Keyring keyring, KeyPairData account) async {
    await keyring.store.deleteAccount(account.pubKey);
  }

  /// check password of account
  Future<bool> checkPassword(KeyPairData account, String pass) async {
    final res = await service!.checkPassword(account.pubKey, pass);
    return res;
  }

  /// change password of account
  Future<KeyPairData?> changePassword(Keyring keyring, String passOld, String passNew) async {
    final acc = keyring.current;
    // 1. change password of keyPair in webView
    final res = await service!.changePassword(acc.pubKey, passOld, passNew);
    if (res == null) {
      return null;
    }
    // 2. if success in webView, then update encrypted seed in local storage.
    await keyring.store.updateEncryptedSeed(acc.pubKey, passOld, passNew);

    // update json meta data
    service!.updateKeyPairMetaData(res, acc.name);
    // update keyPair date in storage
    await keyring.store.updateAccount(res);
    return KeyPairData.fromJson(res as Map<String, dynamic>);
  }

  /// change name of account
  Future<KeyPairData> changeName(Keyring keyring, String name) async {
    final json = keyring.current.toJson();
    // update json meta data
    service!.updateKeyPairMetaData(json, name);
    // update keyPair date in storage
    await keyring.store.updateAccount(json);
    return KeyPairData.fromJson(json);
  }

  /// Check if derive path is valid, return [null] if valid,
  /// and return error message if invalid.
  Future<String?> checkDerivePath(String seed, String path, CryptoType cryptoType) async {
    final String? res = await service!.checkDerivePath(seed, path, cryptoType);
    return res;
  }

  /// Open a new webView for a DApp,
  /// sign extrinsic or msg for the DApp.
  Future<ExtensionSignResult?> signAsExtension(String password, SignAsExtensionParam param) async {
    final signature = await service!.signAsExtension(password, param.toJson());
    if (signature == null) {
      return null;
    }
    final ExtensionSignResult res = ExtensionSignResult();
    res.id = param.id;
    res.signature = signature['signature'];
    return res;
  }

  Future<VerifyResult?> signatureVerify(String message, String signature, String address) async {
    final res = await service!.signatureVerify(message, signature, address);
    if (res == null) {
      return null;
    }
    return VerifyResult.fromJson(Map<String, dynamic>.of(res as Map<String, dynamic>));
  }
}
