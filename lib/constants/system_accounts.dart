import 'package:flutter/foundation.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/user_citizenship_status.dart';
import 'package:seeds/i18n/constans/constans.i18n.dart';

// Seeds system accounts with special icons. Harvest account, onboarding account, etc.

// TODO(n13): get correct icons from figma
class SystemAccounts {
  static final onboardingContract = MemberModel(
    account: 'join.seeds',
    nickname: 'Onboarding Contract'.i18n,
    image: 'assets/images/community.svg',
    status: describeEnum(UserCitizenshipStatus.unknown),
  );
  static final exchangeContract = MemberModel(
    account: 'tlosto.seeds',
    nickname: 'Exchange Contract'.i18n,
    image: 'assets/images/exchange.svg',
    status: describeEnum(UserCitizenshipStatus.unknown),
  );
  static final harvestContract = MemberModel(
    account: 'harvst.seeds',
    nickname: 'Harvest Contract'.i18n,
    image: 'assets/images/harvest.svg',
    status: describeEnum(UserCitizenshipStatus.unknown),
  );

  static MemberModel? getSystemAccount(String accountName) {
    if (accountName == 'join.seeds') {
      return SystemAccounts.onboardingContract;
    } else if (accountName == 'tlosto.seeds') {
      return SystemAccounts.exchangeContract;
    } else if (accountName == 'harvst.seeds') {
      return SystemAccounts.harvestContract;
    } else {
      return null;
    }
  }

  static bool isSystemAccount(String accountName) {
    if (getSystemAccount(accountName) != null) {
      return true;
    } else {
      return false;
    }
  }
}
