import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seeds/providers/services/firebase/firebase_remote_config.dart';

guardianNotification(bool showGuardianNotification) {
  if (showGuardianNotification && FirebaseRemoteConfigService().featureFlagGuardiansEnabled) {
    return Icon(Icons.brightness_1, size: 18.0, color: Colors.redAccent);
  } else {
    return SizedBox.shrink();
  }
}

