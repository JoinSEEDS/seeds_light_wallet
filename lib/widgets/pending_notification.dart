import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

guardianNotification(bool showGuardianNotification) {
  if (showGuardianNotification) {
    return Icon(Icons.brightness_1, size: 18.0, color: Colors.redAccent);
  } else {
    return Container();
  }
}
