import 'package:flutter/material.dart';

class SnackBarInfo extends SnackBar {
  SnackBarInfo({Key? key, required String title, required ScaffoldMessengerState scaffoldMessengerState})
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

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(this);
  }
}
