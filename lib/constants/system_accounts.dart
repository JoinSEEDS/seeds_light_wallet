// @dart=2.9

import 'package:seeds/models/models.dart';

class SystemAccounts {
  static final onboardingContract = MemberModel(
    account: 'join.seeds',
    nickname: 'Onboarding Contract',
    image: 'assets/images/community.svg'
  );
  static final exchangeContract = MemberModel(
    account: 'tlosto.seeds',
    nickname: 'Exchange Contract',
    image: 'assets/images/exchange.svg'
  );
  static final harvestContract = MemberModel(
    account: 'harvst.seeds',
    nickname: 'Harvest Contract',
    image: 'assets/images/harvest.svg'
  );
}

MemberModel getSystemAccount(String accountName) {
  if (accountName == 'join.seeds') {
    return SystemAccounts.onboardingContract;
  } else if(accountName == 'tlosto.seeds') {
    return SystemAccounts.exchangeContract;
  } else if (accountName == 'harvst.seeds') {
    return SystemAccounts.harvestContract;
  } else {
    return null;
  }
}

bool isSystemAccount(String accountName) {
  return getSystemAccount(accountName) != null ? true : false;
}