import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:seeds/datasource/local/biometrics_service.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/utils/cap_utils.dart';

class InitializeBiometricAuthenticationUseCase extends NoInputUseCase<BiometricAuthStatus> {
  final BiometricsService _biometricsService = BiometricsService(LocalAuthentication());

  @override
  Future<Result<BiometricAuthStatus>> run() async {
    try {
      final isBiometricsAvailable = await _biometricsService.checkBiometrics();
      if (isBiometricsAvailable) {
        final supportedTypes = await _biometricsService.getAvailableBiometrics();
        if (supportedTypes.isNotEmpty) {
          final isValid = await _biometricsService.authenticateBiometric(supportedTypes.first);
          if (isValid) {
            return ValueResult(BiometricAuthStatus.authorized);
          } else {
            return ValueResult(BiometricAuthStatus.unauthorized);
          }
        } else {
          return ValueResult(BiometricAuthStatus.notAvailable);
        }
      } else {
        return ValueResult(BiometricAuthStatus.notAvailable);
      }
    } on PlatformException catch (error) {
      final errorStatus = BiometricAuthStatus.values
          .singleWhere((i) => i.name.inCaps == error.code, orElse: () => BiometricAuthStatus.unknown);
      return ErrorResult(errorStatus);
    } catch (err) {
      return ErrorResult(BiometricAuthStatus.unknown);
    }
  }
}
