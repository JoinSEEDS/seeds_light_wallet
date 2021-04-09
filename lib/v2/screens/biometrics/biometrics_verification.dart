import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/features/biometrics/auth_state.dart';
import 'package:seeds/features/biometrics/auth_type.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/screens/passcode/passcode_screen.dart';
import 'package:seeds/i18n/biometrics_verification.i18n.dart';

class BiometricsVerification extends StatefulWidget {
  const BiometricsVerification({Key key}) : super(key: key);
  @override
  _BiometricsVerificationState createState() => _BiometricsVerificationState();
}

class _BiometricsVerificationState extends State<BiometricsVerification> {
  @override
  void initState() {
    BlocProvider.of<AuthenticationBloc>(context)..add(const InitAuthentication());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          switch (state.preferred) {
            case AuthType.nothing:
              return BiometricsView(title: "Biometrics Disabled".i18n);
            case AuthType.password:
              return const PasscodeScreen();
            case AuthType.fingerprint:
            case AuthType.face:
              return BiometricsView(title: "Loading your SEEDS Wallet...".i18n);
            default:
              return BiometricsView(title: "Initializing Biometrics".i18n);
          }
        },
      ),
    );
  }
}

class BiometricsView extends StatelessWidget {
  final String title;
  const BiometricsView({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final margin = MediaQuery.of(context).size.height / 4;
    return Padding(
      padding: EdgeInsets.only(top: margin, bottom: margin),
      child: Center(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300),
                ),
                if ([AuthState.unauthorized, AuthState.setupNeeded].contains(state.authState))
                  MaterialButton(
                    child: Container(
                      padding: const EdgeInsets.only(left: 17, right: 17, top: 12, bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: Text(
                        state.authState == AuthState.setupNeeded ? "Enable Settings".i18n : "Try Again".i18n,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                    ),
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context).add(const TryAgainBiometric());
                    },
                  ),
                if ([AuthState.unauthorized, AuthState.setupNeeded].contains(state.authState) &&
                    settingsStorage.passcodeActive)
                  MaterialButton(
                    child: Container(
                      padding: const EdgeInsets.only(left: 17, right: 17, top: 12, bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: Text(
                        "Use Passcode".i18n,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                    ),
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context).add(const SetPasscodeAsPrefered());
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
