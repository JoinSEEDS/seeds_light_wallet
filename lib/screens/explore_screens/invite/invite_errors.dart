import 'package:flutter/widgets.dart';
import 'package:seeds/utils/build_context_extension.dart';

enum InviteError {
  inviteFail,
  noEnoughBalance,
  minimumSeedsRequired,
  errorLoadingBalance;

  String localizedDescription(BuildContext context) {
    switch (this) {
      case InviteError.inviteFail:
        return context.loc.inviteCreateMapperError;
      case InviteError.noEnoughBalance:
        return context.loc.inviteAmountChangeMapperNotEnoughBalanceError;
      case InviteError.minimumSeedsRequired:
        return context.loc.inviteAmountChangeMapperMinimumRequiredError;
      case InviteError.errorLoadingBalance:
        return context.loc.inviteBalanceMapperError;
    }
  }
}
