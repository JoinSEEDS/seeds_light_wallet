import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/features/biometrics/auth_bloc.dart';
import 'package:seeds/features/biometrics/auth_commands.dart';
import 'package:seeds/features/biometrics/auth_state.dart';
import 'package:seeds/features/biometrics/auth_type.dart';
import 'package:seeds/widgets/passcode.dart';
import 'package:seeds/i18n/biometrics_verification.i18n.dart';

class BiometricsVerification extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return BiometricsVerificationState();
  }

}

class BiometricsVerificationState extends State<BiometricsVerification> {

  @override
  Widget build(BuildContext context) {
    AuthBloc bloc = Provider.of(context);

    return StreamBuilder<AuthType>(
      stream: bloc.preferred,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          switch (snapshot.data) {
            case AuthType.nothing:
              return buildBiometricsView("Biometrics Disabled".i18n);
            case AuthType.password:
              return UnlockWallet();
            case AuthType.fingerprint:
            case AuthType.face:
              return buildBiometricsView("Loading your SEEDS Wallet...".i18n);
          }
        } else {
          bloc.execute(InitAuthenticationCmd());
        }
        return buildBiometricsView("Initializing Biometrics".i18n);
      }
    );

  }

  Widget buildBiometricsView(String title) {
    AuthBloc bloc = Provider.of(context);
    final margin = MediaQuery.of(context).size.height / 4;

    return Scaffold(
      backgroundColor: AppColors.blue,
      body: Padding(
        padding: EdgeInsets.only(top: margin, bottom: margin),
        child: Center(
          child: StreamBuilder<AuthState>(
            stream: bloc.authenticated,
            initialData: AuthState.init,
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                  ...buildUnauthorized(bloc, snapshot.data),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  List<Widget> buildUnauthorized(AuthBloc bloc, AuthState state) {
    if([AuthState.unauthorized, AuthState.setupNeeded].contains(state)) {
      return [
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
              state == AuthState.setupNeeded ? "Enable Settings".i18n : "Try Again".i18n,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w300
              ),
            ),
          ),
          onPressed: () {
            bloc.execute(AuthenticateCmd(AuthType.password));
          },
        ),
        buildPasscodeFallback(),
      ];
    }
    return [
      Container(),
      Container(),
    ];
  }

  StreamBuilder<bool> buildPasscodeFallback() {
    AuthBloc bloc = Provider.of(context);

    return StreamBuilder<bool>(
      stream: bloc.passcodeAvailable,
      initialData: false,
      builder: (context, snapshot) {
        if(snapshot.data) {
          return MaterialButton(
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
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w300
                ),
              ),
            ),
            onPressed: () {
              bloc.execute(ChangePreferredCmd(AuthType.password));
            },
          );
        } else {
          return Container();
        }
      }
    );
  }

}