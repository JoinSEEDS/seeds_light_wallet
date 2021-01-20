import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  Widget buildSplashBody() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 140, left: 44, right: 44),
            child: Image(
              image: AssetImage('assets/images/seeds_light_wallet_logo.png'),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: Center(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 140, left: 44, right: 44),
            child: Image(image: AssetImage('assets/images/seeds_light_wallet_logo.png'))),
      ),
    );
  }
}
