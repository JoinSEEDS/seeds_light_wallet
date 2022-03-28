import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/plant_seeds_errors.dart';

class ShowError extends PageCommand {
  final PlantSeedsError error;

  ShowError(this.error);
}
