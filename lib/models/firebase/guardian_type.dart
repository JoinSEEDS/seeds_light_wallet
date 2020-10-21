import 'package:flutter/foundation.dart';

enum GuardianType {
  myGuardian,
  imGuardian,
}

extension GuardianTypeExtension on GuardianType {
  String get name => describeEnum(this);
}
