import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SendLoadingIndicator extends StatelessWidget {
  const SendLoadingIndicator({super.key});

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
