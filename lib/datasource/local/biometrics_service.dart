import 'package:flutter/services.dart' show PlatformException;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

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
    late AndroidAuthMessages androidAuthStrings;
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
        localizedReason: 'Use your device to authenticate',
        authMessages: [const IOSAuthMessages(), androidAuthStrings],
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          stickyAuth: true,
          biometricOnly: true,
        ),
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

enum BiometricAuthStatus {
  initial,

  /// Biomtric authenticacion was succesful
  authorized,

  /// Biomtric authenticacion was fail
  unauthorized,

  /// Indicates that the user has not yet configured a passcode (iOS) or
  /// PIN/pattern/password (Android) on the device.
  passcodeNotSet,

  /// Indicates the user has not enrolled any fingerprints on the device.
  notEnrolled,

  /// Indicates the device does not have a Touch ID/fingerprint scanner.
  notAvailable,

  /// Indicates the device operating system is not iOS or Android.
  otherOperatingSystem,

  /// Indicates the API lock out due to too many attempts.
  lockedOut,

  /// Indicates the API being disabled due to too many lock outs.
  /// Strong authentication like PIN/Pattern/Password is required to unlock.
  permanentlyLockedOut,

  unknown
}
