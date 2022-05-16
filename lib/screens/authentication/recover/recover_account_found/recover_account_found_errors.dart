import 'package:flutter/widgets.dart';
import 'package:seeds/utils/build_context_extension.dart';

enum RecoverAccountFoundError {
  noGuardians,
  unknown;

  String localizedDescription(BuildContext context) {
    switch (this) {
      case RecoverAccountFoundError.noGuardians:
        return context.loc.recoverAccountFoundMapperNoGuardiansError;
      case RecoverAccountFoundError.unknown:
        return context.loc.recoverAccountFoundMapperUnknownError;
    }
  }
}
