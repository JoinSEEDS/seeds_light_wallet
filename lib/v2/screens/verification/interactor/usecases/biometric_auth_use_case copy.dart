import 'package:async/async.dart';
import 'package:local_auth/local_auth.dart';
import 'package:seeds/features/biometrics/biometrics_service.dart';
import 'package:seeds/features/biometrics/auth_state.dart';
import 'package:seeds/features/biometrics/auth_type.dart';
import 'package:seeds/features/biometrics/auth_commands.dart';

class BiometricAuthUseCase {
  final BiometricsService _service = BiometricsService(LocalAuthentication());

  Future<Result> run(AuthType? authType) async {
    try {
      final isValid = await _service.authenticate(AuthenticateCmd(authType));
      if (isValid) {
        return ValueResult(AuthState.authorized);
      } else {
        print("AuthState.unauthorized (direct)");
        return ValueResult(AuthState.unauthorized);
      }
    } catch (error) {
      return ErrorResult("Error auth with biometrics: $error");
    }
  }
}
