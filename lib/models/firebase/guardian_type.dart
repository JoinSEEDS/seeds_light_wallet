import 'package:flutter/foundation.dart';

enum GuardianType {
  myGuardian,
  imGuardian,
}

extension GuardianTypeExtension on GuardianType {
  String get name => describeEnum(this);
}

GuardianType fromTypeName(String name) {
  switch (name) {
    case "myGuardian":
      return GuardianType.myGuardian;
    case "imGuardian":
      return GuardianType.imGuardian;
    default:
      return GuardianType.myGuardian;
  }
}