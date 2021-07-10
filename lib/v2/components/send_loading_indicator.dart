import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SendLoadingIndicator extends StatelessWidget {
  const SendLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: Lottie.asset(
        'assets/animations/send_animation.json',
        fit: BoxFit.fill,
      )),
    );
  }
}
