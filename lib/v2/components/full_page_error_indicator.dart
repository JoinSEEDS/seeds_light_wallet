import 'package:flutter/material.dart';

class FullPageErrorIndicator extends StatelessWidget {
  const FullPageErrorIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Oops, Something Went Wrong",
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }
}
