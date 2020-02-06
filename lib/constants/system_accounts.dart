import 'package:seeds/models/models.dart';

class SystemAccounts {
  static final JoinSeeds = MemberModel(
    account: 'join.seeds',
    nickname: 'Onboarding Contract',
    image: ''
  );
}

MemberModel getSystemAccount(String accountName) {
  if (accountName == 'join.seeds') {
    return SystemAccounts.JoinSeeds;
  } else {
    return null;
  }
}

bool isSystemAccount(String accountName) {
  return getSystemAccount(accountName) != null ? true : false;
}