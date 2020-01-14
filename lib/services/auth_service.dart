import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {

  final storage = new FlutterSecureStorage();

  Future<String> initializedAccount() async {   
    String accountName = await storage.read(key: 'accountName');

    if (accountName != null && accountName != "") {
      return accountName;
    } else {
      return null;
    }
  }

  Future removeAccount() async {
    await storage.delete(key: 'accountName');
    await storage.delete(key: 'privateKey');
    await storage.delete(key: 'passcode');
  }

  Future<String> getPasscode() async {
    return await storage.read(key: 'passcode');
  }

  Future<void> savePasscode(String passcode) async {
    await storage.write(key: 'passcode', value: passcode);
  }

  Future<String> getAccountName() async {
    return await storage.read(key: 'accountName');
  }

  Future<String> getPrivateKey() async {
    return await storage.read(key: 'privateKey');
  }
}