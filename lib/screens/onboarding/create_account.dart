import 'dart:async';

import 'package:provider/provider.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:seeds/providers/services/config_service.dart';
import 'package:seeds/screens/onboarding/onboarding_method_choice.dart';
import 'package:seeds/screens/onboarding/welcome.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/overlay_popup.dart';
import 'package:seeds/widgets/seeds_button.dart';

class CreateAccount extends StatefulWidget {
  final String inviteSecret;

  CreateAccount(this.inviteSecret);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

Future<bool> isExistingAccount(String accountName) => Future.sync(() => false);

class _CreateAccountState extends State<CreateAccount> {
  final formKey = GlobalKey<FormState>();

  final accountNameController = MaskedTextController(
      mask: '@@@@@@@@@@@@',
      translator: {'@': RegExp(r'[a-z1234]')}
  );

  final StreamController<bool> _statusNotifier =
      StreamController<bool>.broadcast();

  final StreamController<String> _messageNotifier =
      StreamController<String>.broadcast();

  bool loading = false;

  FocusNode accountNameFocus = FocusNode();

  @override
  void didChangeDependencies() {
    if (accountNameController.text == "") {
      accountNameController.updateText(ConfigService.of(context).value("DEBUG_ACCOUNT_NAME"));
    }
    super.didChangeDependencies();
  }

  Future createAccount() async {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();

      setState(() => loading = true);

      accountNameFocus.unfocus();

      String accountName = accountNameController.text;

      EOSPrivateKey privateKey = EOSPrivateKey.fromRandom();
      EOSPublicKey publicKey = privateKey.toEOSPublicKey();

      try {
        var response = await Provider.of<EosService>(context).createAccount(
          accountName,
          publicKey.toString(),
          widget.inviteSecret,
        );

        if (response == null || response["transaction_id"] == null)
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        OverlayPopup(
          title: "Create account",
          body: Form(
            key: formKey,
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
              padding: EdgeInsets.only(bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    focusNode: accountNameFocus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Account name",
                    ),
                    style: TextStyle(
                      fontFamily: "sfprotext",
                      color: Colors.black,
                      fontSize: 32,
                    ),
                    maxLength: 12,
                    validator: (val) {
                      if (val.length != 12)
                        return 'Your account name should have exactly 12 symbols';
                      if (RegExp(r'0|6|7|8|9').allMatches(val).length > 0)
                        return 'Your account name should have digits only 1-5';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: SeedsButton(
                      "Create account",
                      () async => await createAccount(),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        loading ? buildPreLoader() : Container(),
      ],
    );
  }

  Widget buildPreLoader() {
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
}
