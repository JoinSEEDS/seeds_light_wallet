import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:seeds/v2/datasource/local/biometrics_service.dart';
import 'package:seeds/v2/screens/authentication/verification/interactor/model/auth_commands.dart';
import 'package:seeds/v2/screens/authentication/verification/interactor/model/auth_state.dart';
import 'package:seeds/v2/screens/authentication/verification/interactor/model/auth_type.dart';

class BiometricAuthUseCase {
  final BiometricsService _service = BiometricsService(LocalAuthentication());

  Future<Result> run(AuthType authType) async {
    try {
      final isValid = await _service.authenticate(AuthenticateCmd(authType));
      if (isValid) {
        return ValueResult(AuthState.authorized);
      } else {
        print("AuthState.unauthorized (direct)");
        return ValueResult(AuthState.unauthorized);
      }
    } on PlatformException catch (error) {
      return ErrorResult(error.code);
    }
  }
}
