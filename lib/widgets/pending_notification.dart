import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_remote_config.dart';

Widget guardianNotification(bool showGuardianNotification) {
  // featureFlagGuardiansEnabled will no used anymore here
  if (showGuardianNotification && remoteConfigurations.featureFlagGuardiansEnabled) {
    return const Icon(Icons.brightness_1, size: 18.0, color: Colors.redAccent);
  } else {
    return const SizedBox.shrink();
  }
}
