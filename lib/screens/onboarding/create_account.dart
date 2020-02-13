import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
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

  String _validateAccountName(String val) {
    if (val.length != 12) {
      return 'Your account name should have exactly 12 symbols';
    } else if (RegExp(r'0|6|7|8|9').allMatches(val).length > 0) {
      return 'Your account name should only contain number 1-5';
    } else if (val.toLowerCase() != val) {
      return "Your account name can't cont'n uppercase letters";
    } else if (RegExp(r'[a-z]|1|2|3|4|5').allMatches(val).length != 12) {
      return 'Your account name should only contain number 1-5';
    } else if (RegExp(r'[a-z]').allMatches(val[0]).length == 0) {
      return 'Your account name should lower case letter';
    }
    return null;
  }

  List<Widget> createSuggestions() {
    final suggestions = List<String>();

    String suggestion;

    final inputName = _accountName.isNotEmpty ? _accountName : _name;
    // remove uppercase
    if (inputName.toLowerCase() != inputName) {
      suggestion = inputName.toLowerCase();
    }

    // replace 0|6|7|8|9 with 1
    if (RegExp(r'0|6|7|8|9').allMatches(inputName).length > 0) {
      suggestion = inputName.replaceAll(RegExp(r'0|6|7|8|9'), '');
    }

    // remove characters out of the accepted range
    suggestion = inputName.split('').map((char) {
      final legalChar = RegExp(r'[a-z]|1|2|3|4|5').allMatches(char).length > 0;

      return legalChar ? char.toString() : '';
    }).join();

    // remove the first char if it was a number
    if (suggestion?.isNotEmpty == true) {
      final illegalChar =
          RegExp(r'[a-z]').allMatches(suggestion[0]).length == 0;

      if (illegalChar) suggestion = suggestion.substring(1);
    }

    // add the missing characters.
    if (suggestion.length < 12) {
      final missingCharsCount = 12 - suggestion.length;

      final missingChars = (inputName.hashCode.toString() * 2)
          .split('')
          .map((char) => int.parse(char).clamp(1, 5))
          .take(missingCharsCount)
          .join();

      suggestion = (suggestion ?? inputName) + missingChars;
    }

    suggestions.add(suggestion);

    return suggestions.map(buildSuggestionWidget).toList();
  }

  FutureLoadingBuilder<String> buildSuggestionWidget(String suggestion) {
    return FutureLoadingBuilder<String>(
      future: getValidAccountName(suggestion),
      mutable: true,
      builder: (context, suggestion) {
        return InkWell(
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
        );
      },
    );
  }

  Future<String> getValidAccountName(
    String suggestion, {
    int triedIndex = 0,
  }) async {
    final isAvailable = await HttpService.of(context, listen: false)
        .checkAccountName(suggestion);
    if (isAvailable) {
      return suggestion;
    } else {
      final newSuggestion = replaceCharAt(
        suggestion,
        suggestion.length - 1 - triedIndex,
        Random().nextInt(6).clamp(1, 5).toString(),
      );
      return await getValidAccountName(newSuggestion,
          triedIndex: triedIndex + 1);
    }
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
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
                validator: _validateAccountName,
                onChanged: (value) {
                  setState(() => _accountName = value);
                },
              ),
              if (_validateAccountName(_accountName) != null &&
                  (_accountName.isNotEmpty || _name.isNotEmpty))
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Wrap(
                    children: <Widget>[
                      Text('Available: '),
                      ...createSuggestions(),
                    ],
                  ),
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
