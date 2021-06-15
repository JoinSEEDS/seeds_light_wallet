import 'package:async/async.dart';
import 'package:local_auth/local_auth.dart';
import 'package:seeds/features/biometrics/biometrics_service.dart';
import 'package:seeds/features/biometrics/auth_type.dart';

class BiometricsAvailablesUseCase {
  final BiometricsService _service = BiometricsService(LocalAuthentication());

  Future<Result<List<AuthType>>> run() async {
    List<AuthType> supportedAndSorted = [];
    try {
      final isAvailable = await _service.checkBiometrics();
      if (isAvailable) {
        final deviceTypes = await _service.getAvailableBiometrics();
        if (deviceTypes.contains(BiometricType.fingerprint)) {
          supportedAndSorted.insert(0, AuthType.fingerprint);
        }
        if (deviceTypes.contains(BiometricType.face)) {
          supportedAndSorted.insert(0, AuthType.face);
        }
      }
    } catch (error) {
      return ErrorResult("Error checking biometrics: $error");
    }

    return ValueResult(supportedAndSorted);
  }
}
