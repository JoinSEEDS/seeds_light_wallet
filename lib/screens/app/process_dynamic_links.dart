import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:seeds/features/scanner/telos_signing_manager.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/esr_service.dart';
import 'package:seeds/providers/services/links_service.dart';
import 'package:seeds/screens/app/wallet/custom_transaction.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:convert/convert.dart';

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

  void processIdentityRequest(SeedsESR request) async {
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
        var response = await EsrService().getIdentityResponse(
          request: request,
          accountName: SettingsNotifier.of(context, listen: false).accountName,
          walletPrivateKey: SettingsNotifier.of(context, listen: false).privateKey,
        );

        var theresponse = await post(
          response.callback,
          body: response.body,
        );

        print(theresponse);
      } catch (err) {
        print(err);
      }
    }
  }

  void processTransactionRequest(SeedsESR request) async {
    await request.resolve(
      account: SettingsNotifier.of(context, listen: false).accountName,
    );

    var action = request.actions.first;
    var data = Map<String, dynamic>.from(action.data);

    var arguments = await EsrService().getTransactionArguments(
      request: request,
      accountName: SettingsNotifier.of(context, listen: false).accountName,
    );

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
        pageBuilder: (BuildContext context, _, __) => CustomTransaction(arguments),
      ),
    );
  }

  void processSigningRequests() {
    Provider.of<LinksService>(context, listen: false).listenSigningRequests((final link) async {
      if (link == null) {
        return;
      }

      if (link.startsWith("esr")) {
        var request = SeedsESR(uri: link);

        if (request.manager.data.req[0] == "identity") {
          processIdentityRequest(request);
        } else {
          processTransactionRequest(request);
        }
      } else if (link.startsWith("seeds")) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => WebWallet(
            url: link.replace("seeds", "https"),
          ));
        );
      }
    });
  }
}
