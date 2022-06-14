import 'package:flutter/widgets.dart';
import 'package:seeds/utils/build_context_extension.dart';

enum RecoverAccountSearchError {
  noActiveGuardians,
  unableToLoadGuardians,
  unableToLoadAccount,
  invalidAccount;

  String localizedDescription(BuildContext context) {
    switch (this) {
      case RecoverAccountSearchError.noActiveGuardians:
        return context.loc.recoverAccountSearchErrorNoActiveGuardians;
      case RecoverAccountSearchError.unableToLoadGuardians:
        return context.loc.recoverAccountSearchErrorLoadingGuardians;
      case RecoverAccountSearchError.unableToLoadAccount:
        return context.loc.recoverAccountSearchErrorLoadingAccount;
      case RecoverAccountSearchError.invalidAccount:
        return context.loc.recoverAccountSearchErrorNoValidAccount;
    }
  }
}
