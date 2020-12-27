import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/generated/r.dart';
import 'package:seeds/widgets/second_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main_button.dart';

class BroadcastTransactionOverlay extends StatefulWidget {
  final Stream<bool> statusStream;
  final Stream<String> messageStream;
  final Function onClose;

  BroadcastTransactionOverlay(
      {@required this.statusStream, this.messageStream, this.onClose});

  @override
  _BroadcastTransactionOverlayState createState() =>
      _BroadcastTransactionOverlayState();
}

enum Steps { progress, success, failure }

class _BroadcastTransactionOverlayState
    extends State<BroadcastTransactionOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  StreamSubscription<bool> statusSubscription;
  StreamSubscription<String> messageSubscription;

  String message = "";

  Steps step = Steps.progress;

  @override
  void initState() {
    super.initState();

    if (widget.messageStream != null) {
      messageSubscription = widget.messageStream.listen(_messageListener);
    }
    statusSubscription = widget.statusStream.listen(_statusListener);

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  void _messageListener(String resultMessage) {
    setState(() {
      message = resultMessage;
    });
  }

  void _statusListener(status) async {
    if (status == true) {
      setState(() {
        this.step = Steps.success;
      });
    } else {
      setState(() {
        this.step = Steps.failure;
      });
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    statusSubscription?.cancel();
    messageSubscription?.cancel();
    super.dispose();
  }

  Widget closeButton() => MainButton(
        title: "Continue",
        onPressed: () {
          if (widget.onClose != null) {
            widget.onClose();
          } else {
            Navigator.of(context).maybePop();
          }
        },
      );

  Widget detailsButton() => SecondButton(
        title: "Show in Explorer",
        onPressed: () async {
          String url = '${Config.explorer}/transaction/$message';

          if (await canLaunch(url)) {
            await launch(url);
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaY: 10,
                sigmaX: 10,
              ),
              child: Container(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          if (this.step == Steps.progress)
            Align(
              alignment: Alignment.center,
              child: RotationTransition(
                child: Image.asset(
                  'assets/images/loading.png',
                  width: 100,
                  height: 100,
                ),
                turns: Tween(begin: 0.0, end: 2.0).animate(
                  animationController,
                ),
              ),
            ),
          if (this.step == Steps.failure)
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Transaction failed",
                        style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0, top: 24.0),
                        child: SvgPicture.asset(
                          R.error,
                          color: AppColors.red,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Color(0xFFf4f4f4),
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        padding: EdgeInsets.all(15),
                        child: Text(
                          message,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      closeButton(),
                    ],
                  ),
                ],
              ),
            ),
          if (this.step == Steps.success)
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Transaction success",
                        style: TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0, top: 24.0),
                        child: SvgPicture.asset(
                          R.success,
                          color: AppColors.blue,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Color(0xFFf4f4f4),
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Transaction Hash: $message',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      closeButton(),
                      SizedBox(height: 10),
                      detailsButton(),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
