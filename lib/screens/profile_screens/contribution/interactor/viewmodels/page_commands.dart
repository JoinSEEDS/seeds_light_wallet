import 'package:seeds/domain-shared/page_command.dart';

class NavigateToScoreDetails extends PageCommand {
  final int score;
  final String title;
  final String subtitle;
  final String scoreType;

  NavigateToScoreDetails({
    required this.score,
    required this.title,
    required this.subtitle,
    required this.scoreType,
  });
}
