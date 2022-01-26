import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SignUpError {
  FailedToCreateAccount,
  UsernameAlreadyTaken,
  NoInvitesFound,
  InviteAlreadyClaimed,
  InviteHashNotFound,
  QRCodeScanFailed,
  ValidationFailedSelectUsername,
  ValidationFailedOnlyNumbers15,
  ValidationFailedNameLowercaseOnly,
  ValidationFailedNoSpecialCharactersOrSpaces,
  ValidationFailedUsernameMustBe12Characters
}

extension LocalizedSignUpError on SignUpError {
  String localizedDescription(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    switch (this) {
      case SignUpError.FailedToCreateAccount:
        return localization.signUpErrorFailedToCreateAccount;
      case SignUpError.UsernameAlreadyTaken:
        return localization.signUpErrorUsernameAlreadyTaken;
      case SignUpError.NoInvitesFound:
        return localization.signUpErrorNoInvitesFound;
      case SignUpError.InviteAlreadyClaimed:
        return localization.signUpErrorInviteAlreadyClaimed;
      case SignUpError.InviteHashNotFound:
        return localization.signUpErrorInviteHashNotFound;
      case SignUpError.QRCodeScanFailed:
        return localization.signUpErrorQRCodeScanFailed;
      case SignUpError.ValidationFailedSelectUsername:
        return localization.signUpErrorValidationFailedSelectUsername;
      case SignUpError.ValidationFailedOnlyNumbers15:
        return localization.signUpErrorValidationFailedOnlyNumbers15;
      case SignUpError.ValidationFailedNameLowercaseOnly:
        return localization.signUpErrorValidationFailedNameLowercaseOnly;
      case SignUpError.ValidationFailedNoSpecialCharactersOrSpaces:
        return localization.signUpErrorValidationFailedNoSpecialCharactersOrSpaces;
      case SignUpError.ValidationFailedUsernameMustBe12Characters:
        return localization.signUpErrorValidationFailedUsernameMustBe12Characters;
    }
  }
}
