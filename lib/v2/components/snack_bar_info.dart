import 'package:flutter/material.dart';

class SnackBarInfo extends SnackBar {
  final String title;
  final ScaffoldMessengerState scaffoldMessengerState;

  SnackBarInfo(this.title, this.scaffoldMessengerState, {Key? key})
      : super(
          key: key,
          content: Row(
            children: [
              Expanded(child: Text(title, textAlign: TextAlign.center)),
              InkWell(
                child: const Icon(Icons.close),
                onTap: () => scaffoldMessengerState.hideCurrentSnackBar(),
              ),
            ],
          ),
        );

  void show() => scaffoldMessengerState.showSnackBar(this);
}
