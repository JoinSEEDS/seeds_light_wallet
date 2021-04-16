import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/i18n/invites.i18n.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/links_service.dart';
import 'package:seeds/utils/invites.dart';
import 'package:seeds/widgets/available_balance.dart';
import 'package:seeds/widgets/fullscreen_loader.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/main_text_field.dart';
import 'package:seeds/widgets/second_button.dart';
import 'package:seeds/widgets/transaction_details.dart';
import 'package:share/share.dart';
import 'package:qr_flutter/qr_flutter.dart';

enum InviteStatus {
  initial,
  transaction,
  share,
}

class CreateInviteTransaction extends StatefulWidget {
  final String? inviteHash;
  final Function? nextStep;

  const CreateInviteTransaction({this.inviteHash, this.nextStep});

  @override
  CreateInviteTransactionState createState() => CreateInviteTransactionState();
}

class CreateInviteTransactionState extends State<CreateInviteTransaction> {
  bool transactionSubmitted = false;

  final StreamController<bool> _statusNotifier = StreamController<bool>.broadcast();
  final StreamController<String> _messageNotifier = StreamController<String>.broadcast();

  final quantityController = TextEditingController(text: '5');

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
      await Provider.of<EosService>(context, listen: false).createInvite(
        quantity: double.parse(quantityController.text),
        inviteHash: widget.inviteHash,
      );
      widget.nextStep!();
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
      successButtonText: "Show invite code".i18n,
      failureButtonCallback: () {
        setState(() {
          transactionSubmitted = false;
        });
      },
    );
  }

  Widget buildTransactionForm() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 17),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TransactionDetails(
                image: SvgPicture.asset("assets/images/community.svg"),
                title: "Invite friend".i18n,
                beneficiary: "join.seeds",
              ),
              AvailableBalance(),
              MainTextField(
                keyboardType: TextInputType.number,
                controller: quantityController,
                labelText: 'Invite amount (minimum: 5)'.i18n,
                endText: 'SEEDS',
              ),
              MainButton(
                margin: const EdgeInsets.only(top: 25),
                title: 'Create invite'.i18n,
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
  final String? inviteSecret;
  final String? inviteLink;

  const ShareScreen({this.inviteSecret, this.inviteLink});

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  bool secretShared = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[],
            ),
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'GREAT!'.i18n,
                    style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: QrImage(
                    data: widget.inviteLink!,
                    size: 256,
                    foregroundColor: Colors.black87,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Text(
                    'Share this QR code or send link for the person you want to invite!'.i18n,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.blue, fontSize: 16),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                MainButton(
                  title: 'Share Link'.i18n,
                  onPressed: () {
                    setState(() {
                      secretShared = true;
                    });
                    Share.share(widget.inviteLink!);
                  },
                ),
                MainButton(
                  title: 'Share Code'.i18n,
                  margin: const EdgeInsets.only(top: 10),
                  onPressed: () {
                    setState(() {
                      secretShared = true;
                    });
                    Share.share(widget.inviteSecret!);
                  },
                ),
                SecondButton(
                  margin: const EdgeInsets.only(bottom: 40, top: 10),
                  title: 'Done'.i18n,
                  onPressed: () => Navigator.of(context).maybePop(),
                )
              ],
            )
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
  String? _readableSecretCode;
  String? _hashedSecretCode;
  String? _dynamicSecretLink;

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
        await Provider.of<LinksService>(context, listen: false).createInviteLink(_readableSecretCode);

    setState(() {
      _dynamicSecretLink = dynamicSecretLink.toString();
      status = InviteStatus.share;
    });
  }

  @override
  Widget build(BuildContext context) {
    late Widget inviteScreen;

    switch (status) {
      case InviteStatus.initial:
        inviteScreen = const Center(
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
