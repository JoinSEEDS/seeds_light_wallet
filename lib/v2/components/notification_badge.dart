import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final bool isVisible;
  const NotificationBadge({Key key, @required this.isVisible})
      : assert(isVisible != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return isVisible ? const Icon(Icons.brightness_1, size: 18.0, color: Colors.redAccent) : const SizedBox.shrink();
  }
}
