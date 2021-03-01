import 'package:flutter/material.dart';

class FullPageErrorIndicator extends StatelessWidget {
  final String errorMessage;

  const FullPageErrorIndicator({this.errorMessage, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          errorMessage ?? "Oops, Something Went Wrong",
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }
}
