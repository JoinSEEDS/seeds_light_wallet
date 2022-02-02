import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  validationFailedUsernameMustBe12Characters
}

extension LocalizedSignUpError on SignUpError {
  String localizedDescription(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    switch (this) {
      case SignUpError.failedToCreateAccount:
        return localization.signUpErrorFailedToCreateAccount;
      case SignUpError.usernameAlreadyTaken:
        return localization.signUpErrorUsernameAlreadyTaken;
      case SignUpError.noInvitesFound:
        return localization.signUpErrorNoInvitesFound;
      case SignUpError.inviteAlreadyClaimed:
        return localization.signUpErrorInviteAlreadyClaimed;
      case SignUpError.inviteHashNotFound:
        return localization.signUpErrorInviteHashNotFound;
      case SignUpError.qRCodeScanFailed:
        return localization.signUpErrorQRCodeScanFailed;
      case SignUpError.validationFailedSelectUsername:
        return localization.signUpErrorValidationFailedSelectUsername;
      case SignUpError.validationFailedOnlyNumbers15:
        return localization.signUpErrorValidationFailedOnlyNumbers15;
      case SignUpError.validationFailedNameLowercaseOnly:
        return localization.signUpErrorValidationFailedNameLowercaseOnly;
      case SignUpError.validationFailedNoSpecialCharactersOrSpaces:
        return localization.signUpErrorValidationFailedNoSpecialCharactersOrSpaces;
      case SignUpError.validationFailedUsernameMustBe12Characters:
        return localization.signUpErrorValidationFailedUsernameMustBe12Characters;
    }
  }
}
