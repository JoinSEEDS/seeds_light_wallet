import 'package:flutter/widgets.dart';
import 'package:seeds/utils/build_context_extension.dart';

enum ProposalsError { unableToLoad }

extension LocalizedProposalsError on ProposalsError {
  String localizedDescription(BuildContext context) {
    switch (this) {
      case ProposalsError.unableToLoad:
        return context.loc.proposalsUnableToLoadError;
    }
  }
}
