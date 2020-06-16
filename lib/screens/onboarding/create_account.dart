import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/features/account/create_account_bloc.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/i18n/create_account.i18n.dart';

class CreateAccount extends StatefulWidget {
  final String inviteSecret;
  final String initialName;
  final Function(String nickName) onSubmit;

  CreateAccount({this.inviteSecret, this.initialName, this.onSubmit});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

Future<bool> isExistingAccount(String accountName) => Future.sync(() => false);

class _CreateAccountState extends State<CreateAccount> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  var _name = '';

  var accountNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _name = widget.initialName;
    _nameController.text = _name;
  }

  createAccountName() async {
    print("create acct ");

    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();

      accountNameFocus.unfocus();

      print("siubmite $_name");

      widget.onSubmit(_name);
    }
  }

  String _validateName(String val) {
    if (val.isEmpty) {
      return 'Please enter your name'.i18n;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    CreateAccountBloc bloc = Provider.of(context);

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
                labelText: "Name",
                hintText: "Enter your name",
                textInputAction: TextInputAction.next,
                onEditingComplete: () => {createAccountName()},
                controller: _nameController,
                validator: _validateName,
                onChanged: (value) {
                  setState(() => _name = value);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: StreamBuilder<bool>(
                    stream: bloc.available,
                    initialData: false,
                    builder: (context, snapshot) {
                      return MainButton(
                        title: "Next".i18n,
                        active: _name != null && _name.length >= 3,
                        onPressed: () async => await createAccountName(),
                      );
                    }),
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
                              " symbols (lowercase letters and digits only 1-5)"
                                  .i18n),
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
