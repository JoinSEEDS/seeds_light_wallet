import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FullPageLoadingIndicator extends StatelessWidget {
  const FullPageLoadingIndicator({
    Key? key,
    this.width = 126,
    this.height = 126,
  }) : super(key: key);

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
