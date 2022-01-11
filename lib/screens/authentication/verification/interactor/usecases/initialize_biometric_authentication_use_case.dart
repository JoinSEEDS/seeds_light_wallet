import 'package:async/async.dart';
import 'package:local_auth/local_auth.dart';
import 'package:seeds/datasource/local/biometrics_service.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/verification_bloc.dart';

class InitializeBiometricAuthenticationUseCase {
  final BiometricsService _biometricsService = BiometricsService(LocalAuthentication());

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
          return ValueResult(BiometricAuthStatus.setupNeeded);
        }
      } else {
        return ValueResult(BiometricAuthStatus.setupNeeded);
      }
    } catch (error) {
      return ErrorResult("Error checking biometrics: $error");
    }
  }
}
