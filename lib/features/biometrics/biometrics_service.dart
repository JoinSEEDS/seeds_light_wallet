import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart' show PlatformException;

class BiometricsService {

  final LocalAuthentication _localAuth;

  BiometricsService(LocalAuthentication localAuth) :
      _localAuth = localAuth;

  Future<bool> checkBiometrics() async {
    try {
      return _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> authenticate() async {
    try {
      return _localAuth.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint to authenticate',
        useErrorDialogs: true,
        stickyAuth: true
      );
    } on PlatformException catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<bool> cancelAuthentication() {
    try {
      return _localAuth.stopAuthentication();
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

}