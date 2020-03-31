import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:teloswallet/constants/config.dart';
import 'package:teloswallet/widgets/main_button.dart';
import 'package:http/http.dart';

enum Steps { EnterPhone, RequestCode, EnterCode, SubmitCode }

class RegisterPhone extends StatefulWidget {
  final Function onSubmit;
  final String publicKey;
  final String accountName;

  RegisterPhone({
    this.onSubmit,
    this.publicKey,
    this.accountName,
  });

  @override
  _RegisterPhoneState createState() => _RegisterPhoneState();
}

class _RegisterPhoneState extends State<RegisterPhone> {
  Steps step = Steps.RequestCode;

  String phoneNumber;
  String smsOtp;
  String response = '';

  bool loading = false;

  void requestCode() async {
    setState(() {
      loading = true;
      response = '';
    });

    String request = '{"smsNumber": $phoneNumber}';
    Map<String, String> headers = {"x-api-key": Config.smsApiKey};

    Response res = await post('https://api.telosapi.com/v1/registrations',
        headers: headers, body: request);

    if (res.statusCode == 200) {
      setState(() {
        step = Steps.EnterCode;
      });
    } else {
      if (res.body.isNotEmpty) {
        setState(() {
          response = res.body;
        });
      }
    }

    setState(() {
      loading = false;
    });
  }

  void submitCode() async {
    setState(() {
      loading = true;
      response = '';
    });

    String request = json.encode({
      "smsNumber": phoneNumber,
      "smsOtp": smsOtp,
      "telosAccount": widget.accountName,
      "ownerKey": widget.publicKey,
      "activeKey": widget.publicKey,
    });

    Map<String, String> headers = {"x-api-key": Config.smsApiKey};

    print("send request ");

    Response res = await post('https://api.telosapi.com/v1/accounts',
        headers: headers, body: request);

    if (res.statusCode == 200) {
      widget.onSubmit();
    } else {
      if (res.body.isNotEmpty) {
        setState(() {
          response = res.body;
        });
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
      padding: EdgeInsets.only(bottom: 5),
      child: Column(
        children: <Widget>[
          step == Steps.EnterPhone || step == Steps.RequestCode
              ? Text("Verify phone number to create free account")
              : Container(),
          SizedBox(height: 16),
          step == Steps.EnterPhone || step == Steps.RequestCode
              ? Container(
                  child: InternationalPhoneNumberInput.withCustomBorder(
                    onInputChanged: (PhoneNumber number) {
                      if (number.phoneNumber.isNotEmpty) {
                        setState(() {
                          phoneNumber = number.phoneNumber;
                        });
                      }
                    },
                    isEnabled: true,
                    autoValidate: true,
                    formatInput: true,
                    hintText: 'Invalid phone number',
                    inputBorder: OutlineInputBorder(),
                    onInputValidated: (bool value) {
                      if (value == true) {
                        setState(() {
                          step = Steps.RequestCode;
                        });
                      }
                    },
                  ),
                )
              : Container(),
          SizedBox(height: 16),
          step == Steps.RequestCode
              ? Container(
                  child: MainButton(
                    title: 'Request Code',
                    onPressed: requestCode,
                  ),
                )
              : Container(),
          SizedBox(height: 16),
          step == Steps.EnterCode || step == Steps.SubmitCode
              ? Container(child: PinInputTextField(onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      step = Steps.SubmitCode;
                      smsOtp = value;
                    });
                  }
                }))
              : Container(),
          SizedBox(height: 16),
          step == Steps.SubmitCode
              ? Container(
                  child: MainButton(
                    title: 'Submit Code',
                    onPressed: submitCode,
                  ),
                )
              : Container(),
          loading == true ? CircularProgressIndicator() : Container(),
          response.isNotEmpty ? Text(response) : Container(),
        ],
      ),
    );
  }
}
