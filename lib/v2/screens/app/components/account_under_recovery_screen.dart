import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_bloc.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_event.dart';

class AccountUnderRecoveryScreen extends StatelessWidget {
  const AccountUnderRecoveryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          FadeInImage.assetNetwork(
              placeholder: "assets/images/guardians/guardian_shield.png",
              image: "assets/images/guardians/guardian_shield.png"),
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 8),
            child: Text(
              "Recovery Mode Initiated",
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'Someone has initiated the '),
                  TextSpan(text: 'Recovery ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          'process for your account. If you did not request to recover your account please select cancel recovery.  '),
                ],
              ),
            ),
          ),
          FlatButtonLong(
            title: "Cancel Recovery",
            onPressed: () async {
              BlocProvider.of<AppBloc>(context).add(const OnStopGuardianActiveRecoveryTapped());
            },
          ),
        ],
      ),
    );
  }
}
