import 'dart:async';

import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:seeds/constants/app_colors.dart';
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

  ContinueRecovery(this.onClaimed, this.onBack);

  @override
  _ContinueRecoveryState createState() => _ContinueRecoveryState();
}

class _ContinueRecoveryState extends State<ContinueRecovery> {

  bool recovering = false;
  bool canClaim = false;
  bool doneSuccess = false;

  @override
  Widget build(BuildContext context) {
    String accountName = SettingsNotifier.of(context).accountName;

    if (recovering) {
      return NotionLoader(
        notion: "Recovering account...",
      );
    } else if (canClaim) {
      return claimReadyComponent(accountName);
    } else if (doneSuccess) {
      return successComponent(accountName);
    }

    return FutureBuilder(
        future: findRecovery(accountName),
        builder: (context, snapshot) {
          var status = RecoveryStatus.loading;

          UserRecoversModel recovers;
          UserGuardiansModel guardians;

          int confirmedGuardians = 0;
          int requiredGuardians;
          int timeLockSeconds = 0;

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
                timeLockSeconds = recovers.completeTimestamp + guardians.timeDelaySec;

                if ((requiredGuardians == 3 && confirmedGuardians >= 2) ||
                    (requiredGuardians > 3 && confirmedGuardians >= 3)) {
                  status = RecoveryStatus.waitingTimelock;

                  if (timeLockSeconds <=
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
                    Text("Waiting for time lock",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            fontFamily: "worksans")),
                    Text(
                      "Recover your account in",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "worksans",
                      ),
                    ),
                    CountdownClock(
                      timeLockSeconds,
                      ()=> setState(() {})
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
              return claimReadyComponent(accountName);

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

  Container claimReadyComponent(String accountName) {
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
                      child: ShareRecoveryLink(),
                    ),

          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: MainButton(
              title: "Claim account",
              onPressed: onClaimButtonPressed,
            ),
          ),
        ],
      ),
    );
  }

  Container successComponent(String accountName) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
      child: Column(
        children: [
          Text("Your account has been recovered",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  fontFamily: "worksans")),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SvgPicture.asset('assets/images/success.svg',
                            color: Colors.greenAccent
                          ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: MainButton(
              title: "Next",
              onPressed: widget.onClaimed
            ),
          ),
        ],
      ),
    );
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

  void onClaimButtonPressed() async {
    print("recovering...");

    setState(() {
      recovering = true;
      canClaim = true;
    });
    
    String accountName = SettingsNotifier.of(context, listen: false).accountName;
    
    try {
      await EosService.of(context, listen: false).claimRecoveredAccount(accountName);
      setState(() {
        recovering = false;
      });
      widget.onClaimed();

    } catch(error) {
      print("Error restoring account ${error.toString()}");
      setState(() {
        recovering = false;
      });
      final snackBar = SnackBar(
        content: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
            Expanded(
              child: Text(
                'An error occured, please try again.'.i18n,
                maxLines: null,
              ),
            ),
          ],
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
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

    print("oublic $publicKey");

    String link = await EosService.of(context, listen: false)
        .generateRecoveryRequest(accountName, publicKey);

    return link;
  }
}

class CountdownClock extends StatefulWidget {
  final int toTime;
  final Function onDone;

  CountdownClock(this.toTime, this.onDone);
  
  @override
  CountdownClockState createState() => CountdownClockState();

}


class CountdownClockState extends State<CountdownClock> {
  Timer _timer;
  var seconds = 0;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  int secondsRemaining() {
    return (widget.toTime - DateTime.now().millisecondsSinceEpoch / 1000).round();
  }
  
  void startTimer() {
    setState(() {
      seconds = secondsRemaining();
    });
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        var s = secondsRemaining();

        if (s <= 0) {
          setState(() {
            _timer.cancel();
            seconds = s;
          });
          widget.onDone();
        } else {
          setState(() {
            seconds = s;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_timer == null) {
      startTimer();
    }
    Duration duration = Duration(seconds: seconds);
    String waitString =
        "${duration.inHours}:${duration.inMinutes.remainder(60).twoDigits()}:${(duration.inSeconds.remainder(60).twoDigits())}";
    return Text("$waitString",
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w600, fontFamily: "worksans"));
  }
}

extension TwoDigitInt on num {
  static var format = NumberFormat("00");
  String twoDigits() {
    return format.format(this);
  }
}