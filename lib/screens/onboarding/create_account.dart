import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/features/account/account_generator_service.dart';
import 'package:seeds/features/account/create_account_bloc.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/i18n/create_account.i18n.dart';

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
      return 'Please enter your name'.i18n;
    }
    return null;
  }

  Widget buildSuggestionWidget(String suggestion) {
    CreateAccountBloc bloc = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 10, bottom: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            _accountNameController.text = suggestion;
            bloc.setUserAccount(suggestion);

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
    CreateAccountBloc bloc = Provider.of(context);
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
                labelText: 'Your name'.i18n,
                controller: _nameController,
                validator: _validateName,
                onChanged: (value) {
                  setState(() => _name = value);
                  bloc.setUserName(value);
                },
              ),
              SizedBox(height: 8),
              MainTextField(
                labelText: 'Account Name'.i18n,
                controller: _accountNameController,
                maxLength: 12,
                focusNode: accountNameFocus,
                validator: accountGeneratorService.validator,
                onChanged: (value) {
                  setState(() => _accountName = value);
                  bloc.setUserAccount(value);
                },
              ),
              StreamBuilder<ValidAccounts>(
                stream: bloc.validAccounts,
                initialData: ValidAccounts.empty(),
                builder: (context, snapshot) {
                  if(snapshot.hasError) {
                    return Text("Failed to generate".i18n);
                  } else {
                    ValidAccounts va = snapshot.data;
                    if(va.inProgress) {
                      return Center(
                        child: CircularProgressIndicator()
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Wrap(
                        children: <Widget>[
                          Text('Available: '.i18n),
                          ...va.latest(4).map(buildSuggestionWidget),
                        ],
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: StreamBuilder<bool>(
                  stream: bloc.available,
                  initialData: false,
                  builder: (context, snapshot) {
                    return MainButton(
                      title: "Create account".i18n,
                      active: snapshot.data,
                      onPressed: () async => await createAccount(),
                    );
                  }
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
                      TextSpan(text: "Your account name should have ".i18n),
                      TextSpan(
                        text: "exactly 12".i18n,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                          text:
                              " symbols (lowercase letters and digits only 1-5)".i18n),
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
