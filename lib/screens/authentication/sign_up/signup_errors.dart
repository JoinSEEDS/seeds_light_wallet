import 'package:flutter/widgets.dart';
import 'package:seeds/utils/build_context_extension.dart';

enum SignUpError {
  failedToCreateAccount,
  usernameAlreadyTaken,
  noInvitesFound,
  inviteAlreadyClaimed,
  inviteHashNotFound,
  qRCodeScanFailed,
  validationFailedSelectUsername,
  validationFailedOnlyNumbers15,
  validationFailedNameLowercaseOnly,
  validationFailedNoSpecialCharactersOrSpaces,
  validationFailedUsernameMustBe12Characters;

  String localizedDescription(BuildContext context) {
    switch (this) {
      case SignUpError.failedToCreateAccount:
        return context.loc.signUpErrorFailedToCreateAccount;
      case SignUpError.usernameAlreadyTaken:
        return context.loc.signUpErrorUsernameAlreadyTaken;
      case SignUpError.noInvitesFound:
        return context.loc.signUpErrorNoInvitesFound;
      case SignUpError.inviteAlreadyClaimed:
        return context.loc.signUpErrorInviteAlreadyClaimed;
      case SignUpError.inviteHashNotFound:
        return context.loc.signUpErrorInviteHashNotFound;
      case SignUpError.qRCodeScanFailed:
        return context.loc.signUpErrorQRCodeScanFailed;
      case SignUpError.validationFailedSelectUsername:
        return context.loc.signUpErrorValidationFailedSelectUsername;
      case SignUpError.validationFailedOnlyNumbers15:
        return context.loc.signUpErrorValidationFailedOnlyNumbers15;
      case SignUpError.validationFailedNameLowercaseOnly:
        return context.loc.signUpErrorValidationFailedNameLowercaseOnly;
      case SignUpError.validationFailedNoSpecialCharactersOrSpaces:
        return context.loc.signUpErrorValidationFailedNoSpecialCharactersOrSpaces;
      case SignUpError.validationFailedUsernameMustBe12Characters:
        return context.loc.signUpErrorValidationFailedUsernameMustBe12Characters;
    }
  }
}
