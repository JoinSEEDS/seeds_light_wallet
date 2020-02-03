import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seeds/widgets/main_button.dart';

class CreateAccount extends StatefulWidget {
  final String inviteSecret;
  final Function onSubmit;

  CreateAccount({this.inviteSecret, this.onSubmit});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

Future<bool> isExistingAccount(String accountName) => Future.sync(() => false);

class _CreateAccountState extends State<CreateAccount> {
  final formKey = GlobalKey<FormState>();

  final _accountNameController = TextEditingController();

  String _accountName = '';

  FocusNode accountNameFocus = FocusNode();

  Future createAccount() async {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();

      accountNameFocus.unfocus();

      widget.onSubmit(_accountName);
    }
  }

  String _validateAccountName(String val) {
    if (val.length != 12)
      return 'Your account name should have exactly 12 symbols';
    if (RegExp(r'0|6|7|8|9').allMatches(val).length > 0)
      return 'Your account name should only contain number 1-5';
    if (val.toLowerCase() != val)
      return "Your account name can't cont'n uppercase letters";
    return null;
  }

  List<Widget> createSuggestions() {
    final suggestions = List<String>();

    String suggestion;
    if (_accountName.toLowerCase() != _accountName) {
      suggestion = _accountName.toLowerCase();
    }
    if (RegExp(r'0|6|7|8|9').allMatches(_accountName).length > 0) {
      suggestion = _accountName.replaceAll(RegExp(r'0|6|7|8|9'), '1');
    }
    if (_accountName.length < 12) {
      final missingChars = 12 - _accountName.length;
      suggestion = (suggestion ?? _accountName) + '_' * missingChars;
    }

    suggestions.add(suggestion);

    return suggestions.map((suggestion) {
      return InkWell(
        onTap: () {
          setState(() {
            _accountNameController.text = suggestion;

            _accountNameController.selection = TextSelection.fromPosition(
                TextPosition(offset: _accountNameController.text.length));
          });
        },
        child: Text(
          suggestion,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
          padding: EdgeInsets.only(bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _accountNameController,
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
                validator: _validateAccountName,
                onChanged: (value) {
                  setState(() => _accountName = value);
                },
              ),
              SizedBox(height: 16),
              if (_validateAccountName(_accountName) != null &&
                  _accountName.isNotEmpty)
                Wrap(
                  children: <Widget>[
                    Text('Available: '),
                    ...createSuggestions(),
                  ],
                ),
              SizedBox(height: 16),
              MainButton(
                title: "Create account",
                onPressed: () async => await createAccount(),
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
    );
  }
}
