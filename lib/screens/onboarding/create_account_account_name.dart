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
  _CreateAccountAccountNameState createState() => _CreateAccountAccountNameState();
}

Future<bool> isExistingAccount(String accountName) => Future.sync(() => false);

class _CreateAccountAccountNameState extends State<CreateAccountAccountName> {
  final formKey = GlobalKey<FormState>();

  final _accountNameController = TextEditingController();
  var _accountName = '';
  var _available = true;
  var accountNameFocus = FocusNode();
  var validAccounts = ValidAccounts.empty();

  @override
  void initState() {
    super.initState();
    _accountName = initialUsername(widget.nickname);
    _accountNameController.text = _accountName;
  }

  createAccount() async {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();

      accountNameFocus.unfocus();

      widget.onSubmit(_accountName, widget.nickname);
    }
  }

  Widget buildSuggestionWidget(String suggestion) {
    CreateAccountBloc bloc = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 10, bottom: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            print("suggest widget $suggestion");



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

  String initialUsername(String nickname) {
    var result = nickname.toLowerCase().trim();
    
    result = result.split('').map((char) {
      final legalChar = RegExp(r'[a-z]|1|2|3|4|5').allMatches(char).length > 0;
      return legalChar ? char.toString() : '';
    }).join();

    result = result.padRight(12, '1');
    result = result.substring(0, 12);

    print("initial user name $result");

    return result;
  }

  @override
  Widget build(BuildContext context) {
    CreateAccountBloc bloc = Provider.of(context);
    bloc.setUserName(initialUsername(widget.nickname));

    AccountGeneratorService accountGeneratorService = Provider.of(context);
    var valid = accountGeneratorService.validator(_accountName) == null;

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
                labelText: 'SEEDS Username'.i18n,
                textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, fontFamily: "worksans"),
                controller: _accountNameController,
                maxLength: 12,
                focusNode: accountNameFocus,
                validator: accountGeneratorService.validator,
                counterStyle: TextStyle(color: valid ? Colors.green : Colors.black45, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: "worksans"),
                onChanged: (value) {
                  print("set state to $value");
                  setState(() => _accountName = value);
                  var isValid = accountGeneratorService.validator(value) == null;
                  print("valud $isValid");

                  if (!validAccounts.contains(value)) {
                    print("set user account ${validAccounts.accounts.map((x)=>x)}");
                    bloc.setUserAccount(value);
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: StreamBuilder<bool>(
                  stream: bloc.available,
                  initialData: false,
                  builder: (context, snapshot) {
                    return MainButton(
                      title: "Create account".i18n,
                      active: valid && _available,
                      onPressed: () async => await createAccount(),
                    );
                  }
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black45,
                      //fontFamily: "worksans",
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
              StreamBuilder<ValidAccounts>(
                stream: bloc.validAccounts,
                initialData: validAccounts,
                builder: (context, snapshot) {
                  if(snapshot.hasError) {
                    return Text("Failed to generate".i18n);
                  } else {
                    validAccounts = snapshot.data;
                    if(validAccounts.inProgress /*&& validAccounts.accounts.length == 0*/) {
                      return Center(
                        child: CircularProgressIndicator()
                      );
                    }
                    print("${validAccounts.accounts}");
                    _available = validAccounts.contains(_accountNameController.text);
                    var accounts = validAccounts.latest(4).where((element) => element != _accountNameController.text).toList();
                    accounts.sort();

                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Wrap(
                        children: <Widget>[
                          //Text('Other: '.i18n),
                          ...accounts.map(buildSuggestionWidget),
                        ],
                      ),
                    );
                  }
                },
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
