import 'package:flutter/material.dart';

import 'customColors.dart';

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
