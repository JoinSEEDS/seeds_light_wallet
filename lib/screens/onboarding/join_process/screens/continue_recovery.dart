import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:flutter/material.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/notion_loader.dart';
import 'package:seeds/widgets/second_button.dart';
import 'package:share/share.dart';

enum RecoveryStatus {
  loading,
  waitingConfirmations,
  waitingTimelock,
  claimReady
}

class ContinueRecovery extends StatefulWidget {
  final String accountName;
  final String privateKey;
  final Function onClaimed;

  ContinueRecovery({this.accountName, this.privateKey, this.onClaimed});

  @override
  _ContinueRecoveryState createState() => _ContinueRecoveryState();
}

class _ContinueRecoveryState extends State<ContinueRecovery> {
  @override
  Widget build(BuildContext context) {
    String accountName = widget.accountName;
    String privateKey = widget.privateKey;

    return FutureBuilder(
        future: findRecovery(accountName),
        builder: (context, snapshot) {
          var status = RecoveryStatus.loading;

          UserRecoversModel recovers;
          UserGuardiansModel guardians;

          int confirmedGuardians = 0;
          int requiredGuardians = 0;

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            recovers = snapshot.data[0];
            guardians = snapshot.data[1];

            if (guardians.exists == true &&
                guardians.guardians?.isNotEmpty == true) {
              status = RecoveryStatus.waitingConfirmations;
              requiredGuardians = guardians.guardians.length;
            }

            if (recovers.exists == true &&
                recovers.guardians?.isNotEmpty == true) {
              confirmedGuardians = recovers.guardians.length;
            }

            if ((requiredGuardians == 3 && confirmedGuardians >= 2) ||
                (requiredGuardians > 3 && confirmedGuardians >= 3)) {
              status = RecoveryStatus.waitingTimelock;

              if (recovers.completeTimestamp + guardians.timeDelaySec <=
                  DateTime.now().millisecondsSinceEpoch / 1000) {
                status = RecoveryStatus.claimReady;
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
                    if (recovers.guardians != null &&
                        recovers.guardians.length > 0)
                      ...recovers.guardians
                          .map((guardian) => Text(guardian,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: "worksans",
                              )))
                          .toList(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ShareRecoveryLink(
                        accountName: accountName,
                        privateKey: privateKey,
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
            default:
              return NotionLoader(
                notion: "Analyzing recovery progress... $accountName",
              );
          }
        });
  }

  Future<List<dynamic>> findRecovery(String accountName) {
    return Future.wait([
      HttpService.of(context).getAccountRecovery(accountName),
      HttpService.of(context).getAccountGuardians(accountName)
    ]);
  }
}

class ShareRecoveryLink extends StatefulWidget {
  final String accountName;
  final String privateKey;

  ShareRecoveryLink({this.accountName, this.privateKey});

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
    String publicKey =
        EOSPrivateKey.fromString(widget.privateKey).toEOSPublicKey().toString();

    String link = await EosService.of(context, listen: false)
        .generateRecoveryRequest(widget.accountName, publicKey);

    return link;
  }
}
