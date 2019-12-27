import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String> initializedAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String accountName = prefs.getString("accountName");

    if (accountName != null && accountName != "") {
      return accountName;
    } else {
      return null;
    }
  }

  Future removeAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove("accountName");
    await prefs.remove("privateKey");
    await prefs.remove("passcode");
  }

  Future<String> getPasscode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString("passcode");
  }

  Future<void> savePasscode(String passcode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("passcode", passcode);
  }

  Future<String> getAccountName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String privateKey = prefs.getString("accountName");

    return privateKey;
  }

  Future<String> getPrivateKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String privateKey = prefs.getString("privateKey");

    return privateKey;
  }
}