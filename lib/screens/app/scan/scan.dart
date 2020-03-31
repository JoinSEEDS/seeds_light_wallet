import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:teloswallet/providers/notifiers/settings_notifier.dart';
import 'package:teloswallet/providers/services/navigation_service.dart';
import 'package:teloswallet/screens/app/scan/custom_transaction.dart';
import 'package:teloswallet/screens/app/scan/signing_request/fill_request_placeholders.dart';
import './signing_request/get_readable_request.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<Scan> {
  String action;
  String account;
  String data;

  bool processing = false;
  String error;

  void processSigningRequest(String uri) async {
    if (processing == true || error != null) return;

    setState(() {
      processing = true;
      error = null;
    });

    try {
      String uriPath = uri.split(':')[1];

      Map<String, dynamic> signingRequest = await getReadableRequest(uriPath);

      var action = signingRequest['action'];
      var account = signingRequest['account'];
      var data = signingRequest['data'];

      Map<String, dynamic> actionData = fillRequestPlaceholders(data, SettingsNotifier.of(context).accountName);

      setState(() {
        processing = false;
        error = null;
      });

      NavigationService.of(context).navigateTo(
        Routes.customTransaction,
        CustomTransactionArguments(
          account: account,
          name: action,
          data: actionData,
        ),
        true,
      );
    } catch (err) {
      print(err.toString());
      setState(() {
        processing = false;
        error = err.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          processing ? Center(child: CircularProgressIndicator()) : Container(),
          error != null ? Text(error) : Container(),
          Expanded(
            child: QrCamera(
              qrCodeCallback: processSigningRequest,
            ),
          ),
        ],
      ),
    );
  }
}
