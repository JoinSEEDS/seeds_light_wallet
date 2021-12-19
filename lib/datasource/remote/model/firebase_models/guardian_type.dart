enum GuardianType {
  myGuardian,
  imGuardian,
}

GuardianType fromTypeName(String? name) {
  switch (name) {
    case "myGuardian":
      return GuardianType.myGuardian;
    case "imGuardian":
      return GuardianType.imGuardian;
    default:
      return GuardianType.myGuardian;
  }
}
