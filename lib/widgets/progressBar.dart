import 'package:flutter/material.dart';
import 'package:seeds/constants/customColors.dart';

class ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LinearProgressIndicator(
        backgroundColor: CustomColors.Green,
      ),
    );
  }
}
