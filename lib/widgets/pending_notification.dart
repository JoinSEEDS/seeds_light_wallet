import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

guardianNotification(bool showGuardianNotification) {
  if (showGuardianNotification) {
    return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Colors.black,
              spreadRadius: -2,
              offset: Offset(0, 2),
            )
          ],
        ));
  } else {
    return Container();
  }
}
