import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';

class FullscreenLoader extends StatefulWidget {
  final Stream<bool> statusStream;
  final Stream<String> messageStream;

  final Duration duration;
  final String successTitle;
  final String failureTitle;

  final Function afterSuccessCallback;
  final Function afterFailureCallback;

  FullscreenLoader({
    @required this.statusStream,
    this.messageStream,
    this.afterSuccessCallback,
    this.afterFailureCallback,
    this.duration = const Duration(milliseconds: 2500),
    this.successTitle = "Transaction successful",
    this.failureTitle = "Transaction failed",
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
  void dispose() {
    super.dispose();
    animationController.dispose();

    if (statusSubscription != null)
      statusSubscription.cancel();

    if (messageSubscription != null)
      messageSubscription.cancel();
  }

  @override
  void initState() {
    print("init loader");

    super.initState();

    if (widget.messageStream != null) {
      messageSubscription = widget.messageStream.listen((resultMessage) {
        print("new message");
        setState(() {
          message = resultMessage;
        });
      });
    }

    statusSubscription = widget.statusStream.listen((status) async {
      print("new status");
      if (status == true) {
        setState(() {
          showSpinner = false;
          showSuccess = true;
          showFailure = false;
        });

        await Future.delayed(widget.duration);

        if (widget.afterSuccessCallback != null)
          widget.afterSuccessCallback();
      } else {
        setState(() {
          showSpinner = false;
          showSuccess = false;
          showFailure = true;
        });

        await Future.delayed(widget.duration);

        if (widget.afterSuccessCallback != null)
          widget.afterFailureCallback();
      }
    });

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animationController.addListener(() {
      if (animationController.status == AnimationStatus.completed) {
        if (showSpinner) {
          animationController.reset();
        }
      } else if (animationController.status == AnimationStatus.dismissed) {
        if (showSpinner) {
          animationController.forward();
        }
      }
    });

    animationController.forward();
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
        showSpinner
            ? Align(
                alignment: Alignment.center,
                child: RotationTransition(
                  child: Image.asset('assets/images/loading.png'),
                  turns:
                      Tween(begin: 0.0, end: 2.0).animate(animationController),
                ),
              )
            : Container(),
        showSuccess
            ? Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/success.png'),
                    SizedBox(
                      height: 25,
                    ),
                    Column(
                        children: <Widget>[
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
                          )
                        ],
                      ),
                  ],
                ),
              )
            : Container(),
        showFailure
            ? Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/failure.png'),
                    SizedBox(
                      height: 25,
                    ),
                    Material(
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.failureTitle,
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
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(),            
      ],
    );
  }
}
