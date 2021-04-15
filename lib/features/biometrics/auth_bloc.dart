import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/features/biometrics/auth_commands.dart';
import 'package:seeds/features/biometrics/auth_state.dart';
import 'package:seeds/features/biometrics/auth_type.dart';
import 'package:seeds/features/biometrics/biometrics_service.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/utils/bloc/cmd_common.dart';

class AuthBloc {
  late BiometricsService _service;
  late AuthNotifier _authNotifier;
  late SettingsNotifier _settingsNotifier;
  final _rawAvailable = BehaviorSubject<List<AuthType>>();
  final _preferred = BehaviorSubject<AuthType>();
  final _authenticated = BehaviorSubject<AuthState>.seeded(AuthState.init);
  final _execute = PublishSubject<AuthCmd>();

  Stream<List<AuthType>> get available => _rawAvailable.stream.map(filterByPasscodeActive);
  Stream<AuthType> get preferred => _preferred.stream;
  Stream<bool> get passcodeAvailable => available.map(passcodeInAvailable);
  Stream<AuthState> get authenticated => _authenticated.stream.distinct();
  Function(AuthCmd) get execute => _execute.add;

  AuthBloc() {
    preferred
        //.where((type) => type == AuthType.fingerprint || type == AuthType.face)
        .listen((type) {
      if (type == AuthType.fingerprint || type == AuthType.face) {
        execute(AuthenticateCmd(type));
      } else if (type == AuthType.nothing) {
        _authenticated.add(AuthState.setupNeeded);
      }
    });
    available.map(preferredAuthType).listen(_preferred.add);

    _execute.listen((cmd) => _executeCommand(cmd));
  }

  AuthType preferredAuthType(List<AuthType> list) {
    if (list.isEmpty) {
      return AuthType.nothing;
    } else {
      return list[0];
    }
  }

  List<AuthType> filterByPasscodeActive(List<AuthType> list) {
    if (!_settingsNotifier.passcodeActive!) {
      list.remove(AuthType.password);
    }
    return list;
  }

  bool passcodeInAvailable(List<AuthType> list) => list.contains(AuthType.password);

  void update(BiometricsService service, AuthNotifier authNotifier, SettingsNotifier settingsNotifier) {
    _service = service;
    _authNotifier = authNotifier;
    _settingsNotifier = settingsNotifier;
  }

  void _executeCommand(AuthCmd cmd) {
    switch (cmd.runtimeType) {
      case InitAuthenticationCmd:
        _checkAvailability();
        break;

      case AuthenticateCmd:
        _authenticate(cmd as AuthenticateCmd);
        break;

      case ChangePreferredCmd:
        _changePreferred(cmd as ChangePreferredCmd);
        break;

      case DisablePasswordCmd:
        _disablePassword();
        break;

      default:
        throw UnknownCmd(cmd);
    }
  }

  void _checkAvailability() {
    _service.checkBiometrics().then((isAvailable) {
      if (isAvailable) {
        _fetchTypes();
      } else {
        _addPasswordToAvailable();
      }
    }).catchError((error) {
      debugPrint("Error checking biometrics: $error");
      _addPasswordToAvailable();
    });
  }

  void _addPasswordToAvailable() {
    if (_settingsNotifier.passcodeActive!) {
      _rawAvailable.add([AuthType.password]);
    } else {
      debugPrint("Passcode not active, ignoring");
    }
  }

  void _fetchTypes() {
    _service.getAvailableBiometrics().then((deviceTypes) {
      List<AuthType> supportedAndSorted = [AuthType.password];
      if (deviceTypes.contains(BiometricType.fingerprint)) {
        supportedAndSorted.insert(0, AuthType.fingerprint);
      }
      if (deviceTypes.contains(BiometricType.face)) {
        supportedAndSorted.insert(0, AuthType.face);
      }
      _rawAvailable.add(supportedAndSorted);
      //_preferred.add(supportedAndSorted[0]);
    }).catchError((error) {
      debugPrint("Error checking biometrics: $error");
      _addPasswordToAvailable();
    });
  }

  void _authenticate(AuthenticateCmd cmd) {
    _service.authenticate(cmd).then((value) {
      if (value) {
        _authenticated.add(AuthState.authorized);
        _authNotifier.unlockWallet();
      } else {
        _authenticated.add(AuthState.unauthorized);
        debugPrint("AuthState.unauthorized (direct)");
      }
    }).catchError((error) {
      debugPrint("Error auth with biometrics: $error");
      _authenticated.addError("Auth error: $error");
      // Biometrics auth failed, Send user to password input.
      _addPasswordToAvailable();
    });
  }

  void _changePreferred(ChangePreferredCmd cmd) {
    _preferred.add(cmd.type);
  }

  void _disablePassword() {
    _authNotifier.disablePasscode();
    _settingsNotifier.passcodeActive = false;
    _fetchTypes();
  }

  void discard() {
    _rawAvailable.close();
    _preferred.close();
    _authenticated.close();
    _execute.close();
  }
}
