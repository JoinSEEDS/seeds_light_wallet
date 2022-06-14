import 'package:flutter/widgets.dart';
import 'package:seeds/utils/build_context_extension.dart';

enum PlantSeedsError {
  errorLoadingPage,
  plantFailed;

  String localizedDescription(BuildContext context) {
    switch (this) {
      case PlantSeedsError.errorLoadingPage:
        return context.loc.genericLoadingPageError;
      case PlantSeedsError.plantFailed:
        return context.loc.plantSeedsPlantFailedError;
    }
  }
}
