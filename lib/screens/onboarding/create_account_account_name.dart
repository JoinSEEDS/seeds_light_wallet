import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/features/account/account_generator_service.dart';
import 'package:seeds/features/account/create_account_bloc.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/i18n/create_account.i18n.dart';

class CreateAccountAccountName extends StatefulWidget {
  final String nickname;
  final Function(String accountName, String nickName) onSubmit;

  CreateAccountAccountName({this.nickname, this.onSubmit});

  @override
  _CreateAccountAccountNameState createState() =>
      _CreateAccountAccountNameState();
}

Future<bool> isExistingAccount(String accountName) => Future.sync(() => false);

class _CreateAccountAccountNameState extends State<CreateAccountAccountName> {
  final formKey = GlobalKey<FormState>();

  final _accountNameController = TextEditingController();
  var accountNameFocus = FocusNode();
  String _accountName;
  bool _initial = true;

  @override
  void initState() {
    super.initState();
    print("INIT STATE ${initialUsername(widget.nickname)}");
    _accountName = initialUsername(widget.nickname);
    _accountNameController.text = initialUsername(widget.nickname);
  }

  createAccount() async {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      accountNameFocus.unfocus();
      widget.onSubmit(_accountNameController.text, widget.nickname);
    }
  }

  String initialUsername(String nickname) {
    var result = nickname.toLowerCase().trim();

    result = result.split('').map((char) {
      final legalChar = RegExp(r'[a-z]|1|2|3|4|5').allMatches(char).length > 0;
      return legalChar ? char.toString() : '';
    }).join();

    result = result.padRight(12, '1');
    result = result.substring(0, 12);

    return result;
  }

  Widget buildAlternatives(BuildContext context, String suggested) {
    AccountGeneratorService accountGeneratorService = Provider.of(context);
    return Container(
      child: FutureBuilder(
          future: accountGeneratorService.generateList(suggested, count: 4),
          builder: (context, snapshot) {
          var isLoading = snapshot.connectionState != ConnectionState.done;

            return Container();
          }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    AccountGeneratorService accountGeneratorService = Provider.of(context);

    return Container(
      child: FutureBuilder(
          future: accountGeneratorService.findAvailable(_accountName),
          builder: (context, snapshot) {
            var isLoading = snapshot.connectionState != ConnectionState.done;
            var availableName = snapshot.hasData ? snapshot.data.available : "";
            if (!isLoading && snapshot.hasData && _initial) {
              _initial = false;
              _accountName = availableName; // this might change the name
              _accountNameController.text = availableName;
            }
            var currentText = _accountNameController.text;
            var errorString = accountGeneratorService.validator(currentText);
            var valid = errorString == null;
            var definitelyAvailableOnChain = !isLoading && availableName == currentText;
            var accountNameIsTaken = valid && !isLoading && availableName != currentText;

            if (accountNameIsTaken) {
              errorString = "$currentText is not availale";
            }

            print(
                "builder text: ${_accountNameController.text}  snapshot: ${snapshot.hasData} data: $availableName");

            return Form(
              key: formKey,
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                padding: EdgeInsets.only(bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(children: [
                      MainTextField(
                        labelText: 'SEEDS Username'.i18n,
                        autocorrect: false,
                        textStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            fontFamily: "worksans"),
                        controller: _accountNameController,
                        maxLength: 12,
                        focusNode: accountNameFocus,
                        validator: accountGeneratorService.validator,
                        counterStyle: TextStyle(
                            color: valid ? Colors.green : Colors.black45,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: "worksans"),
                        onChanged: (value) {
                          setState(() {
                            _accountName = value;
                          });
                        },
                        errorText: errorString,
                        suffixIcon: isLoading
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator()),
                                ],
                              )
                            : definitelyAvailableOnChain
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.greenAccent,
                                    size: 24.0,
                                  )
                                : accountNameIsTaken
                                    ? Icon(
                                        Icons.remove_circle,
                                        color: Colors.redAccent,
                                        size: 24.0,
                                      )
                                    : Container(
                                        width: 1,
                                        color: Colors.transparent,
                                      ),
                      ),
                    ]),
                    Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: MainButton(
                          title: "Create account".i18n,
                          active: valid && definitelyAvailableOnChain,
                          onPressed: () async => await createAccount(),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Your account name should have ".i18n),
                            TextSpan(
                              text: "exactly 12".i18n,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                                text:
                                    " symbols (lowercase letters and digits only 1-5)"
                                        .i18n),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

}
