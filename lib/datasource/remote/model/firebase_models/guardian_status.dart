enum GuardianStatus {
  alreadyGuardian,
  requestedMe,
  requestSent,
  noRelationship,
}

GuardianStatus fromStatusName(String? name) {
  switch (name) {
    case "alreadyGuardian":
      return GuardianStatus.alreadyGuardian;
    case "requestedMe":
      return GuardianStatus.requestedMe;
    case "requestSent":
      return GuardianStatus.requestSent;
    case "noRelationship":
      return GuardianStatus.noRelationship;
    default:
      return GuardianStatus.noRelationship;
  }
}
