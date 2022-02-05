import 'package:flutter/widgets.dart';
import 'package:seeds/utils/build_context_extension.dart';

enum GlobalError { unknown }

extension LocalizedGlobalError on GlobalError {
  String localizedDescription(BuildContext context) {
    switch (this) {
      case GlobalError.unknown:
        return context.loc.globalUnknownError;
    }
  }
}
