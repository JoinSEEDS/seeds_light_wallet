import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/generated/r.dart';
import 'package:seeds/i18n/widgets.i18n.dart';
import 'package:seeds/utils/error_builder.dart';

import 'main_button.dart';

class FullscreenLoader extends StatefulWidget {
  final Stream<bool> statusStream;
  final Stream<String> messageStream;

  final Duration successCallbackDelay;
  final Duration failureCallbackDelay;

  final String _successTitle = "Transaction successful".i18n;
  final String _failureTitle = "Transaction failed".i18n;
  final String _successButtonText = "Done".i18n;
  final String _failureButtonText = "Done".i18n;

  final String successTitle;
  final String failureTitle;
  final String successButtonText;
  final String failureButtonText;

  final Function afterSuccessCallback;
  final Function afterFailureCallback;
  final Function successButtonCallback;
  final Function failureButtonCallback;

  FullscreenLoader({
    @required this.statusStream,
    this.messageStream,
    this.afterSuccessCallback,
    this.afterFailureCallback,
    this.successCallbackDelay = const Duration(milliseconds: 2500),
    this.failureCallbackDelay = const Duration(milliseconds: 2500),
    this.successTitle,
    this.failureTitle,
    this.successButtonText,
    this.failureButtonText,
    this.successButtonCallback,
    this.failureButtonCallback,
  });

  @override
  _FullscreenLoaderState createState() => _FullscreenLoaderState();
}

class _FullscreenLoaderState extends State<FullscreenLoader> with SingleTickerProviderStateMixin {
  AnimationController animationController;

  StreamSubscription<bool> statusSubscription;
  StreamSubscription<String> messageSubscription;

  String message = "";
  bool showSpinner = true;
  bool showSuccess = false;
  bool showFailure = false;

  @override
  void initState() {
    super.initState();

    if (widget.messageStream != null) {
      messageSubscription = widget.messageStream.listen(_messageListener);
    }
    statusSubscription = widget.statusStream.listen(_statusListener);

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  void _messageListener(String resultMessage) {
    setState(() {
      if (showFailure)
        message = ErrorBuilder.getErrorMessageKey(resultMessage);
      else
        message = resultMessage;
    });
  }

  void _statusListener(status) async {
    if (status == true) {
      setState(() {
        showSpinner = false;
        showSuccess = true;
        showFailure = false;
      });

      await Future.delayed(widget.successCallbackDelay);

      if (widget.afterSuccessCallback != null) widget.afterSuccessCallback();
    } else {
      setState(() {
        showSpinner = false;
        showSuccess = false;
        showFailure = true;
      });

      await Future.delayed(widget.failureCallbackDelay);

      if (widget.afterSuccessCallback != null) widget.afterFailureCallback();
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    statusSubscription?.cancel();
    messageSubscription?.cancel();
    super.dispose();
  }

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
          if (showSpinner)
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                double scale = math.sin(math.pi * animationController.value) + 0.8;
                return Align(
                  alignment: Alignment.center,
                  child: Transform.scale(
                    scale: scale,
                    child: RotationTransition(
                      child: Image.asset(
                        R.appIconTransparent,
                        width: 100,
                        height: 100,
                      ),
                      turns: Tween(begin: 0.0, end: 2.0).animate(
                        animationController,
                      ),
                    ),
                  ),
                );
              },
            ),
          if (!showSpinner)
            Container(
              margin: EdgeInsets.only(left: 32, right: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        (showSuccess == true)
                            ? (widget.successTitle == null ? widget._successTitle : widget.successTitle)
                            : (widget.failureTitle == null ? widget._failureTitle : widget.failureTitle),
                        style: TextStyle(
                          color: (showSuccess == true) ? AppColors.blue : AppColors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0, top: 24.0),
                        child: Icon(
                          (showSuccess == true) ? Icons.check_circle : Icons.error,
                          color: (showSuccess == true) ? AppColors.blue : AppColors.red,
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
                          (showFailure == true) ? message.i18n : message,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      MainButton(
                        title: (showSuccess)
                            ? (widget.successButtonText == null ? widget._successButtonText : widget.successButtonText)
                            : (widget.failureButtonText == null ? widget._failureButtonText : widget.failureButtonText),
                        onPressed: () {
                          if (showSuccess && widget.successButtonCallback != null) {
                            widget.successButtonCallback();
                          } else if (showFailure && widget.failureButtonCallback != null) {
                            widget.failureButtonCallback();
                          } else {
                            Navigator.of(context).maybePop();
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
