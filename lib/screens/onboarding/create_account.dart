import 'dart:async';

import 'package:flutter/material.dart';

import 'package:eosdart_ecc/eosdart_ecc.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:seeds/screens/onboarding/onboarding_method_choice.dart';
import 'package:seeds/screens/onboarding/welcome.dart';
import 'package:seeds/services/eos_service.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/overlay_popup.dart';
import 'package:seeds/widgets/seeds_button.dart';

import 'helpers.dart';

class CreateAccount extends StatefulWidget {
  final String inviteSecret;

  CreateAccount(this.inviteSecret);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

Future<bool> isExistingAccount(String accountName) => Future.sync(() => false);

class _CreateAccountState extends State<CreateAccount> {
  var accountNameController = MaskedTextController(
      text: debugAccount,
      mask: '@@@@@@@@@@@@',
      translator: {'@': new RegExp(r'[a-z1234]')});

  final StreamController<bool> _statusNotifier =
      StreamController<bool>.broadcast();

  final StreamController<String> _messageNotifier =
      StreamController<String>.broadcast();

  bool progress = false;

  FocusNode accountNameFocus = FocusNode();

  final EosService eosService = EosService();

  Widget buildPreloader() {
    return FullscreenLoader(
        statusStream: _statusNotifier.stream,
        messageStream: _messageNotifier.stream,
        afterSuccessCallback: () {
          String accountName = accountNameController.text;

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Welcome(accountName),
            ),
          );
        },
        afterFailureCallback: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => OnboardingMethodChoice(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        OverlayPopup(
          title: "Create account",
          body: Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
            padding: EdgeInsets.only(bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 2,
                      child: Text(
                        "Account name",
                        style: TextStyle(fontFamily: "sfprotext"),
                      ),
                    ),
                    Spacer(flex: 1),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 4,
                      child: TextField(
                        focusNode: accountNameFocus,
                        textAlign: TextAlign.left,
                        textDirection: TextDirection.ltr,
                        showCursor: true,
                        enableInteractiveSelection: false,
                        autofocus: true,
                        controller: accountNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontFamily: "sfprotext",
                          color: Colors.black,
                          fontSize: 32,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: SeedsButton(
                    "Create account",
                    () async {
                      setState(() {
                        progress = true;
                      });

                      accountNameFocus.unfocus();

                      String accountName = accountNameController.text;

                      EOSPrivateKey privateKey = EOSPrivateKey.fromRandom();
                      EOSPublicKey publicKey = privateKey.toEOSPublicKey();

                      try {
                        var response = await eosService.acceptInvite(
                          accountName,
                          publicKey.toString(),
                          widget.inviteSecret,
                        );

                        if (response == null ||
                            response["transaction_id"] == null)
                          throw "Unexpected error, please try again";

                        String trxid = response["transaction_id"];

                        await Future.delayed(Duration.zero);
                        _statusNotifier.add(true);
                        _messageNotifier.add("Transaction hash: $trxid");
                      } catch (err) {
                        print(err);

                        await Future.delayed(Duration.zero);
                        _statusNotifier.add(false);
                        _messageNotifier.add(err.toString());
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                RichText(
                  text: TextSpan(
                      style: TextStyle(
                        color: Colors.black45,
                        fontFamily: "worksans",
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: "Your account name should have "),
                        TextSpan(
                          text: "exactly 12",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                            text:
                                " symbols (lowercase letters and digits only 1-5)"),
                      ]),
                ),
              ],
            ),
          ),
        ),
        progress ? buildPreloader() : Container(),
      ],
    );
  }
}
