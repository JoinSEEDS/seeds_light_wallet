import 'package:flutter/services.dart' show PlatformException;
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class BiometricsService {
  final LocalAuthentication _localAuth;

  const BiometricsService(this._localAuth);

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

  Future<bool> authenticateBiometric(BiometricType type) async {
    AndroidAuthMessages androidAuthStrings;
    switch (type) {
      case BiometricType.fingerprint:
        androidAuthStrings = const AndroidAuthMessages(
          biometricHint: 'Biometrics',
          signInTitle: "Fingerprint Authentication",
        );
        break;
      case BiometricType.face:
        androidAuthStrings = const AndroidAuthMessages(
          biometricHint: "Biometrics",
          signInTitle: "Face Authentication",
        );
        break;
      default:
        {
          androidAuthStrings = const AndroidAuthMessages(
            signInTitle: "Authenticate using biometric credentials",
          );
        }
    }
    try {
      return _localAuth.authenticate(
        biometricOnly: true,
        androidAuthStrings: androidAuthStrings,
        localizedReason: 'Use your device to authenticate',
        useErrorDialogs: false,
        stickyAuth: true,
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
