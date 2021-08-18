import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Icon(Icons.brightness_1, size: 18.0, color: Colors.redAccent);
}
