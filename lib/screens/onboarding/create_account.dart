import 'dart:async';
import 'dart:math';

import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/overlay_popup.dart';

class CreateAccount extends StatefulWidget {
  final String inviteSecret;

  CreateAccount(this.inviteSecret);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

Future<bool> isExistingAccount(String accountName) => Future.sync(() => false);

class _CreateAccountState extends State<CreateAccount> {
  final formKey = GlobalKey<FormState>();

  final _accountNameController = TextEditingController();

  final StreamController<bool> _statusNotifier =
      StreamController<bool>.broadcast();

  final StreamController<String> _messageNotifier =
      StreamController<String>.broadcast();

  String _accountName = '';

  bool loading = false;

  FocusNode accountNameFocus = FocusNode();

  createAccount() async {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();

      setState(() => loading = true);

      accountNameFocus.unfocus();

      EOSPrivateKey privateKey = EOSPrivateKey.fromRandom();
      EOSPublicKey publicKey = privateKey.toEOSPublicKey();

      try {
        var response = await EosService.of(context, listen: false).acceptInvite(
          accountName: _accountName,
          publicKey: publicKey.toString(),
          inviteSecret: widget.inviteSecret,
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

  String _validateAccountName(String val) {
    if (val.length != 12) {
      return 'Your account name should have exactly 12 symbols';
    } else if (RegExp(r'0|6|7|8|9').allMatches(val).length > 0) {
      return 'Your account name should only contain number 1-5';
    } else if (val.toLowerCase() != val) {
      return "Your account name can't cont'n uppercase letters";
    } else if (RegExp(r'[a-z]|1|2|3|4|5').allMatches(val).length != 12) {
      return 'Your account name should only contain number 1-5';
    }
    return null;
  }

  // TODO: add debounce so we don't send unnecessary requests.
  List<Widget> createSuggestions() {
    final suggestions = List<String>();

    String suggestion;
    // remove uppercase
    if (_accountName.toLowerCase() != _accountName) {
      suggestion = _accountName.toLowerCase();
    }
    // replace 0|6|7|8|9 with 1
    if (RegExp(r'0|6|7|8|9').allMatches(_accountName).length > 0) {
      suggestion = _accountName.replaceAll(RegExp(r'0|6|7|8|9'), '1');
    }
    // add the missing characters.
    if (_accountName.length < 12) {
      final missingCharsCount = 12 - _accountName.length;

      final missingChars = (_accountName.hashCode.toString() * 2)
          .split('')
          .map((char) => int.parse(char).clamp(1, 5))
          .take(missingCharsCount)
          .join();

      suggestion = (suggestion ?? _accountName) + missingChars;
    }

    suggestions.add(suggestion);

    return suggestions.map((suggestion) {
      return FutureLoadingBuilder<String>(
        future: getValidAccountName(suggestion),
        mutable: true,
        builder: (context, suggestion) {
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
        },
      );
    }).toList();
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
                    onPressed: createAccount,
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
          String accountName = _accountName;

          NavigationService.of(context, listen: false)
              .navigateTo(Routes.welcome, accountName, true);
        },
        afterFailureCallback: () {
          NavigationService.of(context, listen: false)
              .navigateTo("OnboadingMethodChoice", true);
        });
  }
}
