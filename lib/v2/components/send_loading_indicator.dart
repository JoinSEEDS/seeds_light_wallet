import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SendLoadingIndicator extends StatelessWidget {
  const SendLoadingIndicator({
    Key? key,
    this.width = 126,
    this.height = 126,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Lottie.asset(
      'assets/animations/send_animation.json',
      width: width,
      height: height,
      fit: BoxFit.fill,
    )));
  }
}
