import 'package:flutter/material.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/utils/build_context_extension.dart';

// Seeds system accounts with special icons. Harvest account, onboarding account, etc.

// TODO(n13): get correct icons from figma
class SystemAccounts {
  static final onboardingContract = ProfileModel.usingDefaultValues(
    account: 'join.seeds',
    image: 'assets/images/community.svg',
  );
  static final exchangeContract = ProfileModel.usingDefaultValues(
    account: 'tlosto.seeds',
    image: 'assets/images/exchange.svg',
  );
  static final harvestContract = ProfileModel.usingDefaultValues(
    account: 'harvst.seeds',
    image: 'assets/images/harvest.svg',
  );

  static ProfileModel? getSystemAccount(String accountName) {
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

  // Used to provide a localized display name for system accounts instead of using ProfileModel.nickname
  static String? getLocalizedDisplayNameForSystemAccount(String accountName, BuildContext context) {
    if (accountName == 'join.seeds') {
      return context.loc.constantOnboardingContract;
    } else if (accountName == 'tlosto.seeds') {
      return context.loc.constantExchangeContract;
    } else if (accountName == 'harvst.seeds') {
      return context.loc.constantHarvestContract;
    } else {
      return null;
    }
  }
}
