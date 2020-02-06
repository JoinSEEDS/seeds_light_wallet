import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';

import 'main_button.dart';

class FullscreenLoader extends StatefulWidget {
  final Stream<bool> statusStream;
  final Stream<String> messageStream;

  final Duration successCallbackDelay;
  final Duration failureCallbackDelay;

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
    this.successTitle = "Transaction successful",
    this.failureTitle = "Transaction failed",
    this.successButtonText = "Close",
    this.failureButtonText = "Close",
    this.successButtonCallback,
    this.failureButtonCallback,
  });

  @override
  _FullscreenLoaderState createState() => _FullscreenLoaderState();
}

class _FullscreenLoaderState extends State<FullscreenLoader>
    with SingleTickerProviderStateMixin {
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
    print("listen now...");
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
    print("status: $status");

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
    super.dispose();
    animationController?.dispose();
    statusSubscription?.cancel();
    messageSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
              double scale =
                  math.sin(math.pi * animationController.value) + 0.5;
              return Align(
                alignment: Alignment.center,
                child: Transform.scale(
                  scale: scale,
                  child: RotationTransition(
                    child: Image.asset(
                      'assets/images/launcher_icon.png',
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
        if (showSuccess)
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/success.png'),
                SizedBox(
                  height: 25,
                ),
                Text(
                  widget.successTitle,
                  style: TextStyle(
                    fontFamily: "worksans",
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontFamily: "worksans",
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                ),
                MainButton(
                  title: widget.successButtonText,
                  onPressed: () {
                    if (widget.successButtonCallback != null) {
                      widget.successButtonCallback();
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  },
                ),
              ],
            ),
          ),
        if (showFailure)
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/failure.png'),
                SizedBox(
                  height: 25,
                ),
                Material(
                  child: Text(
                    widget.failureTitle,
                    style: TextStyle(
                      fontFamily: "worksans",
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.green,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontFamily: "worksans",
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                ),
                MainButton(
                  title: widget.failureButtonText,
                  onPressed: () {
                    if (widget.failureButtonCallback != null) {
                      widget.failureButtonCallback();
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
