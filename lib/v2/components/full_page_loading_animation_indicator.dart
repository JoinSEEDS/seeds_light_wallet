import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FullPageLoadingAnimationIndicator extends StatelessWidget {
  const FullPageLoadingAnimationIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Lottie.network(
                'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json')));
  }
}
