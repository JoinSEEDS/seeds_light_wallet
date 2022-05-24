import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final accountsKey = 'wallet_account_list';
  final currentAccountKey = 'wallet_current_account';
  final contactsKey = 'wallet_contact_list';
  final seedKey = 'wallet_seed';
  final customKVKey = 'wallet_kv';

  final storage = _LocalStorage();

  Future<void> addAccount(Map<String, dynamic> acc) async {
    return storage.addItemToList(accountsKey, acc);
  }

  Future<void> removeAccount(String? pubKey) async {
    return storage.removeItemFromList(accountsKey, 'pubKey', pubKey);
  }

  Future<List<Map<String, dynamic>>> getAccountList() async {
    return storage.getList(accountsKey);
  }

  Future<bool> setCurrentAccount(String pubKey) async {
    return storage.setKV(currentAccountKey, pubKey);
  }

  Future<String?> getCurrentAccount() async {
    return storage.getKV(currentAccountKey);
  }

  Future<void> addContact(Map<String, dynamic> con) async {
    return storage.addItemToList(contactsKey, con);
  }

  Future<void> removeContact(String address) async {
    return storage.removeItemFromList(contactsKey, 'address', address);
  }

  Future<void> updateContact(Map<String, dynamic> con) async {
    return storage.updateItemInList(contactsKey, 'address', con['address'], con);
  }

  Future<List<Map<String, dynamic>>> getContactList() async {
    return storage.getList(contactsKey);
  }

  Future<bool> setSeeds(String seedType, Map value) async {
    return storage.setKV('${seedKey}_$seedType', jsonEncode(value));
  }

  Future<Map?> getSeeds(String? seedType) async {
    final String? value = await storage.getKV('${seedKey}_$seedType');
    if (value != null) {
      return jsonDecode(value);
    }
    return {};
  }

  Future<bool> setObject(String key, Object value) async {
    final String str = await compute(jsonEncode, value);
    return storage.setKV('${customKVKey}_$key', str);
  }

  Future<Object?> getObject(String key) async {
    final String? value = await storage.getKV('${customKVKey}_$key');
    if (value != null) {
      final Object data = await compute(jsonDecode as FutureOr<Object> Function(dynamic), value);
      return data;
    }
    return null;
  }

  Future<void> setAccountCache(String accPubKey, String key, Object value) async {
    Map? data = await (getObject(key) as FutureOr<Map<dynamic, dynamic>?>);
    data ??= {};
    data[accPubKey] = value;
    await setObject(key, data);
  }

  Future<Object?> getAccountCache(String accPubKey, String key) async {
    final Map? data = await (getObject(key) as FutureOr<Map<dynamic, dynamic>?>);
    if (data == null) {
      return null;
    }
    return data[accPubKey];
  }

  // cache timeout 10 minutes
  static const int customCacheTimeLength = 10 * 60 * 1000;

  static bool checkCacheTimeout(int cacheTime) {
    return DateTime.now().millisecondsSinceEpoch - customCacheTimeLength > cacheTime;
  }
}

class _LocalStorage {
  Future<String?> getKV(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> setKV(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  Future<void> addItemToList(String storeKey, Map<String, dynamic> acc) async {
    List<Map<String, dynamic>> ls = [];

    final String? str = await getKV(storeKey);
    if (str != null) {
      final Iterable l = jsonDecode(str);
      ls = l.map((i) => Map<String, dynamic>.from(i)).toList();
    }

    ls.add(acc);

    await setKV(storeKey, jsonEncode(ls));
  }

  Future<void> removeItemFromList(String storeKey, String itemKey, String? itemValue) async {
    final ls = await getList(storeKey);
    ls.removeWhere((item) => item[itemKey] == itemValue);
    await setKV(storeKey, jsonEncode(ls));
  }

  Future<void> updateItemInList(
      String storeKey, String itemKey, String? itemValue, Map<String, dynamic> itemNew) async {
    final ls = await getList(storeKey);
    ls.removeWhere((item) => item[itemKey] == itemValue);
    ls.add(itemNew);
    await setKV(storeKey, jsonEncode(ls));
  }

  Future<List<Map<String, dynamic>>> getList(String storeKey) async {
    List<Map<String, dynamic>> res = [];

    final String? str = await getKV(storeKey);
    if (str != null) {
      final Iterable l = jsonDecode(str);
      res = l.map((i) => Map<String, dynamic>.from(i)).toList();
    }
    return res;
  }
}
