import 'package:flutter/material.dart';

class SnackBarInfo extends SnackBar {
  SnackBarInfo({Key? key, required String title, required BuildContext context})
      : super(
          key: key,
          content: Row(
            children: [
              Expanded(
                child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle2),
              ),
              InkWell(
                child: const Icon(Icons.close),
                onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              ),
            ],
          ),
        );

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(this);
  }
}
