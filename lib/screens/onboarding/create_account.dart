import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:provider/provider.dart';
import 'package:seeds/features/account/account_generator_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';

class CreateAccount extends StatefulWidget {
  final String inviteSecret;
  final Function(String accountName, String nickName) onSubmit;

  CreateAccount({this.inviteSecret, this.onSubmit});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

Future<bool> isExistingAccount(String accountName) => Future.sync(() => false);

class _CreateAccountState extends State<CreateAccount> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  var _name = '';

  final _accountNameController = TextEditingController();
  var _accountName = '';
  var accountNameFocus = FocusNode();

  createAccount() async {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();

      accountNameFocus.unfocus();

      widget.onSubmit(_accountName, _name);
    }
  }

  String _validateName(String val) {
    if (val.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  Widget buildSuggestionWidget(String suggestion) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 10, bottom: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            _accountNameController.text = suggestion;

            _accountName = suggestion;

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
      ),
    );
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  @override
  Widget build(BuildContext context) {
    AccountGeneratorService accountGeneratorService = Provider.of(context);

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
              MainTextField(
                labelText: 'Your name',
                controller: _nameController,
                validator: _validateName,
                onChanged: (value) {
                  setState(() => _name = value);
                },
              ),
              SizedBox(height: 8),
              MainTextField(
                labelText: 'Account Name',
                controller: _accountNameController,
                maxLength: 12,
                focusNode: accountNameFocus,
                validator: accountGeneratorService.validator, // so cumbersome, rebuild as Bloc I think
                onChanged: (value) {
                  setState(() => _accountName = value);
                },
              ),
              if (accountGeneratorService.validate(_accountName).invalid &&
                  (_accountName.length > 3 || _name.length > 3))
                FutureBuilder<List<String>>(
                  future: accountGeneratorService.generateList(_accountName.isNotEmpty ? _accountName : _name),
                  builder: (context, snapshot) {
                    if(snapshot.hasError) {
                      return Text("Failed to generate");
                    } else if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Wrap(
                          children: <Widget>[
                            Text('Available: '),
                            ...snapshot.data.map(buildSuggestionWidget),
                          ],
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }
                ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: MainButton(
                  title: "Create account",
                  onPressed: () async => await createAccount(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black45,
                      fontFamily: "worksans",
                      fontSize: 14,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
