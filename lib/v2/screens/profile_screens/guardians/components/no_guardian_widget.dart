import 'package:flutter/material.dart';
import 'package:seeds/design/app_theme.dart';

class NoGuardiansWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        "You have added no user to become your guardian yet. Once you do, the request will show here.",
        style: Theme.of(context).textTheme.subtitle2LowEmphasis,
      ),
    ));
  }
}
