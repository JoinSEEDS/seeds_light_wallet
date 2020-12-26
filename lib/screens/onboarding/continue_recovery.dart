import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:flutter/material.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/notion_loader.dart';
import 'package:seeds/widgets/second_button.dart';
import 'package:share/share.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

enum RecoveryStatus {
  loading,
  waitingConfirmations,
  waitingTimelock,
  claimReady,
  noGuardiansFound
}

class ContinueRecovery extends StatefulWidget {
  final Function onClaimed;
  final Function onBack;

  ContinueRecovery(
      this.onClaimed, this.onBack);

  @override
  _ContinueRecoveryState createState() => _ContinueRecoveryState();
}

class _ContinueRecoveryState extends State<ContinueRecovery> {
  @override
  Widget build(BuildContext context) {
    String accountName = SettingsNotifier.of(context).accountName;

    return FutureBuilder(
        future: findRecovery(accountName),
        builder: (context, snapshot) {
          var status = RecoveryStatus.loading;



          UserRecoversModel recovers;
          UserGuardiansModel guardians;

          int confirmedGuardians = 0;
          int requiredGuardians;

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            recovers = snapshot.data[0];
            guardians = snapshot.data[1];

            print("recovers: ${recovers.exists}");
            print("guardians: ${guardians.exists}");

            if (!guardians.exists) {
              status = RecoveryStatus.noGuardiansFound;
            } else {
              status = RecoveryStatus.waitingConfirmations;
              requiredGuardians = guardians.guardians.length;
              if (!recovers.exists) {
                confirmedGuardians = 0;
              } else {
                confirmedGuardians = recovers.guardians.length;

                if ((requiredGuardians == 3 && confirmedGuardians >= 2) ||
                    (requiredGuardians > 3 && confirmedGuardians >= 3)) {
                  status = RecoveryStatus.waitingTimelock;

                  if (recovers.completeTimestamp + guardians.timeDelaySec <=
                      DateTime.now().millisecondsSinceEpoch / 1000) {
                    status = RecoveryStatus.claimReady;
                  }
                }
              }
            }
          }

          switch (status) {
            case RecoveryStatus.waitingConfirmations:
              return Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                child: Column(
                  children: [
                    Text(
                      "Waiting For Confirmations",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontFamily: "worksans",
                      ),
                    ),
                    Text(
                      " $confirmedGuardians of $requiredGuardians guardians signed: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: "worksans",
                      ),
                    ),
                    ...(recovers.guardians ?? [])
                        .map((guardian) => Text(guardian,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: "worksans",
                            )))
                        .toList(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ShareRecoveryLink(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SecondButton(
                        title: "Refresh",
                        onPressed: () => setState(() {}),
                      ),
                    ),
                  ],
                ),
              );
            case RecoveryStatus.waitingTimelock:
              return Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                child: Column(
                  children: [
                    Text("Waiting timelock",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: "worksans")),
                    Text(
                      "Need to wait another ${(recovers.completeTimestamp + guardians.timeDelaySec - DateTime.now().millisecondsSinceEpoch / 1000).round()} seconds",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "worksans",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SecondButton(
                        title: "Refresh",
                        onPressed: () => setState(() {}),
                      ),
                    ),
                  ],
                ),
              );
            case RecoveryStatus.claimReady:
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                child: Column(
                  children: [
                    Text("Account recovered $accountName",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: "worksans")),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: MainButton(
                        title: "Claim account",
                        onPressed: widget.onClaimed,
                      ),
                    ),
                  ],
                ),
              );
            case RecoveryStatus.noGuardiansFound:
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                child: Column(
                  children: [
                    Text("No guardians found for $accountName",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: "worksans")),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: MainButton(
                        title: "Cancel",
                        onPressed: widget.onBack,
                      ),
                    ),
                  ],
                ),
              );

            default:
              return NotionLoader(
                notion: "Analyzing recovery progress... $accountName",
              );
          }
        });
  }

  Future<void> showCancelDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Recovery?'.i18n),
          actions: [
            FlatButton(
              child: Text("Yes".i18n),
              onPressed: () {
                Navigator.pop(context);
                widget.onBack();
              },
            ),
            FlatButton(
              child: Text("No".i18n),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<dynamic>> findRecovery(String accountName) {
    return Future.wait([
      HttpService.of(context).getAccountRecovery(accountName),
      HttpService.of(context).getAccountGuardians(accountName)
    ]);
  }
}

class ShareRecoveryLink extends StatefulWidget {

  ShareRecoveryLink();

  @override
  _ShareRecoveryLinkState createState() => _ShareRecoveryLinkState();
}

class _ShareRecoveryLinkState extends State<ShareRecoveryLink> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: generateRecoveryLink(),
      builder: (context, snapshot) {
        return AnimatedCrossFade(
          duration: Duration(milliseconds: 500),
          firstChild: MainButton(
            title: "Share recovery link",
            onPressed: () {
              Share.share(snapshot.data);
            },
          ),
          secondChild: Text("Creating link..."),
          crossFadeState: snapshot.connectionState == ConnectionState.done
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        );
      },
    );
  }

  Future<String> generateRecoveryLink() async {

    String accountName = SettingsNotifier.of(context).accountName;
    String pKey = SettingsNotifier.of(context).privateKey;

    print("GR acct $accountName $pKey");

    String publicKey =
        EOSPrivateKey.fromString(pKey).toEOSPublicKey().toString();

    String link = await EosService.of(context, listen: false)
        .generateRecoveryRequest(accountName, publicKey);

    return link;
  }
}
