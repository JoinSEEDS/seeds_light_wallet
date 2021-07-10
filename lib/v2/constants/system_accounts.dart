import 'package:seeds/v2/datasource/remote/model/member_model.dart';

// TODO(n13): get correct icons from figma
class SystemAccounts {
  static final onboardingContract =
      const MemberModel(account: 'join.seeds', nickname: 'Onboarding Contract', image: 'assets/images/community.svg');
  static final exchangeContract =
      const MemberModel(account: 'tlosto.seeds', nickname: 'Exchange Contract', image: 'assets/images/exchange.svg');
  static final harvestContract =
      const MemberModel(account: 'harvst.seeds', nickname: 'Harvest Contract', image: 'assets/images/harvest.svg');

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
