import 'package:flutter/widgets.dart';
import 'package:seeds/utils/build_context_extension.dart';

enum RecoverAccountFoundError { noGuardians, unknown }

extension LocalizedRecoverAccountErrors on RecoverAccountFoundError {
  String localizedDescription(BuildContext context) {
    switch (this) {
      case RecoverAccountFoundError.noGuardians:
        return context.loc.recoverAccountFoundMapperNoGuardiansError;
      case RecoverAccountFoundError.unknown:
        return context.loc.recoverAccountFoundMapperUnknownError;
    }
  }
}
