import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/links_service.dart';
import 'package:seeds/utils/invites.dart';
import 'package:seeds/widgets/available_balance.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/widgets/transaction_details.dart';
import 'package:share/share.dart';

enum InviteStatus {
  initial,
  transaction,
  share,
}

class CreateInviteTransaction extends StatefulWidget {
  final String inviteHash;
  final Function nextStep;

  CreateInviteTransaction({this.inviteHash, this.nextStep});

  @override
  CreateInviteTransactionState createState() => CreateInviteTransactionState();
}

class CreateInviteTransactionState extends State<CreateInviteTransaction> {
  bool transactionSubmitted = false;

  final StreamController<bool> _statusNotifier =
      StreamController<bool>.broadcast();
  final StreamController<String> _messageNotifier =
      StreamController<String>.broadcast();

  final sowController = TextEditingController(text: '5');
  final transferController = TextEditingController(text: '2');

  @override
  void dispose() {
    _statusNotifier.close();
    _messageNotifier.close();
    super.dispose();
  }

  void onSend() async {
    setState(() {
      transactionSubmitted = true;
    });

    FocusScope.of(context).requestFocus(FocusNode());

    try {
      var response =
          await Provider.of<EosService>(context, listen: false).createInvite(
        transferQuantity: double.parse(transferController.text),
        sowQuantity: double.parse(sowController.text),
        inviteHash: widget.inviteHash,
      );
      
      String transactionId = response["transaction_id"];

      print("notify now...");

      _statusNotifier.add(true);
      _messageNotifier.add("Transaction hash: $transactionId");
    } catch (err) {
      print(err.toString());
      _statusNotifier.add(false);
      _messageNotifier.add(err.toString());
    }
  }

  Widget buildProgressOverlay() {
    return FullscreenLoader(
      statusStream: _statusNotifier.stream,
      messageStream: _messageNotifier.stream,
      successButtonCallback: widget.nextStep,
      successButtonText: "Show invite code",
      failureButtonCallback: () {
        setState(() {
          transactionSubmitted = false;
        });
        Navigator.of(context).maybePop();
      },
    );
  }

  Widget buildTransactionForm() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 17),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TransactionDetails(
                image: Image.asset("assets/images/explorer2.png"),
                title: "Invite friend",
                beneficiary: "join.seeds",
              ),
              AvailableBalance(),
              MainTextField(
                keyboardType: TextInputType.number,
                controller: sowController,
                labelText: 'Sow amount (minimum: 5)',
                endText: 'SEEDS',
              ),
              MainTextField(
                keyboardType: TextInputType.number,
                controller: transferController,
                labelText: 'Transfer amount',
                endText: 'SEEDS',
              ),
              MainButton(
                margin: EdgeInsets.only(top: 25),
                title: 'Create invite',
                onPressed: onSend,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildTransactionForm(),
        transactionSubmitted ? buildProgressOverlay() : Container(),
      ],
    );
  }
}

class ShareScreen extends StatefulWidget {
  final String inviteSecret;
  final String inviteLink;

  ShareScreen({this.inviteSecret, this.inviteLink});

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  bool secretShared = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Share invite",
          style: TextStyle(color: Colors.black, fontFamily: "worksans"),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.inviteSecret,
              style: TextStyle(fontFamily: "worksans", fontSize: 18),
            ),
            Text(
              widget.inviteLink,
              style: TextStyle(fontFamily: "worksans", fontSize: 14),
            ),
            SizedBox(height: 14),
            MainButton(
              title: "Share link",
              onPressed: () {
                setState(() {
                  secretShared = true;
                });
                Share.share(widget.inviteLink);
              },
            ),
            SizedBox(height: 12),
            secretShared == true
                ? MainButton(
                    title: "Close",
                    onPressed: () {
                      Navigator.of(context).maybePop();
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class CreateInvite extends StatefulWidget {
  @override
  _CreateInviteState createState() => _CreateInviteState();
}

class _CreateInviteState extends State<CreateInvite> {
  InviteStatus status = InviteStatus.initial;
  String _readableSecretCode;
  String _hashedSecretCode;
  String _dynamicSecretLink;

  @override
  void didChangeDependencies() {
    if (status == InviteStatus.initial) {
      prepareInviteSecret();
    }

    super.didChangeDependencies();
  }

  void prepareInviteSecret() async {
    String inviteMnemonic = generateMnemonic();
    String inviteSecret = secretFromMnemonic(inviteMnemonic);
    String inviteHash = hashFromSecret(inviteSecret);

    print("invite mnemonic: $inviteMnemonic");
    print("invite secret: $inviteSecret");
    print("invite hash: $inviteHash");

    setState(() {
      _readableSecretCode = inviteMnemonic;
      _hashedSecretCode = inviteHash;
      status = InviteStatus.transaction;
    });
  }

  void prepareInviteLink() async {
    Uri dynamicSecretLink =
        await Provider.of<LinksService>(context, listen: false)
            .createInviteLink(_readableSecretCode);

    setState(() {
      _dynamicSecretLink = dynamicSecretLink.toString();
      status = InviteStatus.share;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget inviteScreen;

    switch (status) {
      case InviteStatus.initial:
        inviteScreen = Center(
          child: CircularProgressIndicator(),
        );
        break;

      case InviteStatus.transaction:
        inviteScreen = CreateInviteTransaction(
          inviteHash: _hashedSecretCode,
          nextStep: prepareInviteLink,
        );
        break;

      case InviteStatus.share:
        inviteScreen = ShareScreen(
          inviteSecret: _readableSecretCode,
          inviteLink: _dynamicSecretLink,
        );
        break;
    }

    return inviteScreen;
  }
}
