import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FullPageLoadingIndicator extends StatelessWidget {
  const FullPageLoadingIndicator({
    super.key,
    this.width = 126,
    this.height = 126,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(
      'assets/animations/forest.json',
      width: width,
      height: height,
      fit: BoxFit.fill,
    ));
  }
}
