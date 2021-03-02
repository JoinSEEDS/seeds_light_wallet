import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:dart_esr/dart_esr.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:seeds/features/scanner/telos_signing_manager.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/links_service.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';
import 'package:eosdart/src/serialize.dart' as ser;

class ProcessDynamicLinks extends StatefulWidget {
  final Widget child;

  ProcessDynamicLinks({@required this.child});

  @override
  _ProcessDynamicLinksState createState() => _ProcessDynamicLinksState();
}

class _ProcessDynamicLinksState extends State<ProcessDynamicLinks> {
  @override
  void initState() {
    super.initState();
    processSigningRequests();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void processIdentityRequest(request) async {
    var defaultPermission = {"actor": SettingsNotifier.of(context, listen: false).accountName, "permission": "active"};

    bool doesNotHavePermission =
        request.manager.data.req[1] == null || request.manager.data.req[1]["permission"] == null;

    if (doesNotHavePermission) {
      request.manager.data.req[1]["permission"] = defaultPermission;
    }

    var confirmed = await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Confirm Authorization"),
            actions: [
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text("Confirm"),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        });

    if (confirmed == true) {
      try {
        var abis = await request.manager.fetchAbis();

        var signer = Authorization()
          ..actor = SettingsNotifier.of(context, listen: false).accountName
          ..permission = "active";

        ResolvedSigningRequest resolved = request.manager.resolve(abis, signer, null);

        var signBuf = Uint8List.fromList(
            List.from(ser.stringToHex(chainId))..addAll(resolved.serializedTransaction)..addAll(Uint8List(32)));

        var walletPrivateKey = SettingsNotifier.of(context, listen: false).privateKey;

        var signature = EOSPrivateKey.fromString(walletPrivateKey).sign(signBuf).toString();

        var transactionId = resolved.getTransactionId().toLowerCase();
        var body = """{
                "tx": "$transactionId",
                "sig": "$signature", 
                "rbn": "${resolved.transaction.refBlockNum.toString()}",
                "rid": "${resolved.transaction.refBlockPrefix.toString()}",
                "ex": "${resolved.transaction.expiration.toString()}",
                "req": "${resolved.request.encode()}",
                "sa": "${resolved.signer.actor}",
                "sp": "${resolved.signer.permission}",
                "cid": "$chainId"
              }""";

        await post(
          request.manager.data.callback,
          body: body,
        );
      } catch (err) {
        print(err);
      }
    }
  }

  void processTransactionRequest(request) async {
    await request.resolve(
      account: SettingsNotifier.of(context, listen: false).accountName,
    );

    var action = request.actions.first;
    var data = Map<String, dynamic>.from(action.data);

    Navigator.of(context).push(
      PageRouteBuilder(
          opaque: false,
          fullscreenDialog: true,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            var tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.bounceInOut,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child, // child is the value returned by pageBuilder
            );
          },
          pageBuilder: (BuildContext context, _, __) => CustomTransaction(CustomTransactionArguments(
                account: action.account,
                name: action.name,
                data: data,
              ))),
    );
  }

  void processSigningRequests() {
    Provider.of<LinksService>(context, listen: false).listenSigningRequests((final link) async {
      if (link == null) {
        return;
      }

      var request = SeedsESR(uri: link);

      if (request.manager.data.req[0] == "identity") {
        processIdentityRequest(request);
      } else {
        processTransactionRequest(request);
      }
    });
  }
}
