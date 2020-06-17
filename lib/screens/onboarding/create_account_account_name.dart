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
  var _searchMode = true;
  var _inited = false;
  var accountNameFocus = FocusNode();
  CreateAccountBloc _bloc;

  @override
  void initState() {
    super.initState();
    print("INIT STATE ${initialUsername(widget.nickname)}");
    _searchMode = true;
    _accountNameController.text = initialUsername(widget.nickname);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_inited) {
      _bloc = Provider.of(context);
      print("setting username");
      
      _bloc.setUserName(_accountNameController.text);
      
      print("done setting username");

      _inited = true;
    }
  }

  createAccount() async {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      accountNameFocus.unfocus();
      widget.onSubmit(_accountNameController.text, widget.nickname);
    }
  }

  Widget buildSuggestionWidget(String suggestion) {
    CreateAccountBloc bloc = _bloc;
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 10, bottom: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            _accountNameController.text = suggestion;
            bloc.setUserAccount(suggestion);

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

  Widget buildSelection(
      BuildContext context, AsyncSnapshot<ValidAccounts> snapshot) {
    if (snapshot.hasError) {
      return Text("Failed to generate".i18n);
    } else {
      var validAccounts = snapshot.data;
      if (validAccounts.inProgress /*&& validAccounts.accounts.length == 0*/) {
        return Center(child: CircularProgressIndicator());
      }
      //_available = validAccounts.contains(_accountNameController.text);
      var accounts = validAccounts
          .latest(4)
          .where((element) => element != _accountNameController.text)
          .toList();
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
  }

  @override
  Widget build(BuildContext context) {
    CreateAccountBloc bloc = _bloc;

    AccountGeneratorService accountGeneratorService = Provider.of(context);

    return Container(
      child: StreamBuilder<ValidAccounts>(
          stream: bloc.validAccounts,
          initialData: ValidAccounts.empty(),
          builder: (context, snapshot) {

            var currentText = _accountNameController.text;
            var errorString = accountGeneratorService.validator(currentText);
            var valid = errorString == null;
            var validAccounts = snapshot.data;
            var available = validAccounts.contains(currentText);
            var inProgress = validAccounts.inProgress;

            print(
                "builder text: ${_accountNameController.text} search: $_searchMode snapshot: ${snapshot.data.accounts} inProgress: $inProgress");

            if (valid && !available && !inProgress) {
              print("$currentText is valid but not available..");
              if (_searchMode && validAccounts.accounts.length > 0) {
                errorString = null;
                _searchMode = false;
                //_accountNameController.text = validAccounts.accounts.first;
                available = true;
              } else {
                errorString = "Not available".i18n;
              }
            } else if (currentText.length < 12) {
              errorString = null;
            }

            var showProgress = inProgress && valid && !available;
            var showOk = available;
            var showError = valid && !available && !inProgress;

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
                          print("on change");
                          bloc.setUserName(value);
                        },
                        errorText: errorString,
                        suffixIcon: showProgress
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
                            : showOk
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.greenAccent,
                                    size: 24.0,
                                  )
                                : showError
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
                      child: StreamBuilder<bool>(
                          stream: bloc.available,
                          initialData: false,
                          builder: (context, snapshot) {
                            return MainButton(
                              title: "Create account".i18n,
                              active: valid && available,
                              onPressed: () async => await createAccount(),
                            );
                          }),
                    ),
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
                    buildSelection(context, snapshot),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
